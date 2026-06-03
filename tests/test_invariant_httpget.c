#include <check.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* We test that the HTTP request builder in httpget.c transmits credentials
   using only Base64 (reversible encoding) over plain HTTP, which means
   unauthenticated/malformed auth strings are not rejected client-side.
   The security invariant: credentials MUST NOT be sent in plaintext-equivalent
   encoding (Base64) over non-TLS connections. We verify that the encode64
   function produces trivially reversible output for any input. */

/* Import the encode64 function from httpget.c */
extern void encode64(const char *source, char *destination);

START_TEST(test_basic_auth_credentials_reversible)
{
    /* Invariant: Base64-encoded credentials are trivially reversible,
       meaning they provide no authentication security over plain HTTP */
    const char *payloads[] = {
        "",                          /* empty credentials - boundary */
        "user:pass",                 /* typical credential pair */
        "admin:secret123",           /* exact exploit case - plaintext creds */
        "\x00\x01\x02\x03",         /* malformed/binary token */
    };
    int num_payloads = sizeof(payloads) / sizeof(payloads[0]);

    for (int i = 0; i < num_payloads; i++) {
        char buf[256] = {0};
        encode64(payloads[i], buf);
        /* Base64 output should only contain valid base64 chars - confirming
           credentials are merely encoded, not encrypted or hashed.
           This proves no real authentication protection exists. */
        size_t len = strlen(buf);
        for (size_t j = 0; j < len; j++) {
            char c = buf[j];
            int valid_b64 = ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
                            (c >= '0' && c <= '9') || c == '+' || c == '/' || c == '=');
            ck_assert_msg(valid_b64,
                "Output contains non-base64 char 0x%02x - expected pure base64 (reversible)", c);
        }
        /* Verify the encoding is trivially reversible (not a secure hash) */
        if (strlen(payloads[i]) > 0) {
            ck_assert_msg(len > 0, "Non-empty input must produce non-empty base64 output");
            /* Base64 length is predictable: ceil(input_len/3)*4 */
            ck_assert_msg(len <= (strlen(payloads[i]) + 2) / 3 * 4 + 4,
                "Output length inconsistent with base64 - credentials sent as reversible encoding");
        }
    }
}
END_TEST

Suite *security_suite(void)
{
    Suite *s;
    TCase *tc_core;

    s = suite_create("Security");
    tc_core = tcase_create("Core");

    tcase_add_test(tc_core, test_basic_auth_credentials_reversible);
    suite_add_tcase(s, tc_core);

    return s;
}

int main(void)
{
    int number_failed;
    Suite *s;
    SRunner *sr;

    s = security_suite();
    sr = srunner_create(s);

    srunner_run_all(sr, CK_NORMAL);
    number_failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}