#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <commctrl.h>
#include <commdlg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "config_dialog.h"
#include "resource.h"

#include "regconfig.h"

#ifndef CBM_FIRST
#define CBM_FIRST 0x1700
#endif
#ifndef CB_SETMINVISIBLE
#define CB_SETMINVISIBLE (CBM_FIRST+1)
#endif

typedef int (*BankNamesCount)(void);
typedef const char *const *(*BankNamesList)(void);

static const char *const volume_models_descriptions[] =
{
    "Auto (defined by bank)",
    "Generic",
    "OPL3 Native",
    "DMX",
    "Apogee Sound System",
    "Win9x",
    NULL
};

static const char * const emulator_type_descriptions[] =
{
    "MAME YM2612 (OPN2)",
    "Nuked OPN2 (YM3438)",
    "GENS/GS II OPN2",
    "YMFM OPN2",
    "Neko Project II Kai OPNA",
    "MAME YM2610 (OPNA)",
    "YMFM OPNA",
    "Nuked OPN2 (YM2612)",
    NULL
};

static DriverSettings g_setup;
static HINSTANCE      s_hModule;

static void syncBankType(HWND hwnd, int type);
static void syncWidget(HWND hwnd);
static void buildLists(HWND hwnd);
static void syncBankType(HWND hwnd, int type);
static void openCustomBank(HWND hwnd);
static void updateBankName(HWND hwnd, const WCHAR *filePath);

static void syncWidget(HWND hwnd)
{
    char buff[10];
    int i;

    SendDlgItemMessage(hwnd, IDC_BANK_EXTERNAL, BM_SETCHECK, 0, 0);
    SendDlgItemMessage(hwnd, IDC_BANK_INTERNAL, BM_SETCHECK, 0, 0);

    if(g_setup.useExternalBank == 1)
        SendDlgItemMessage(hwnd, IDC_BANK_EXTERNAL, BM_SETCHECK, 1, 0);
    else
        SendDlgItemMessage(hwnd, IDC_BANK_INTERNAL, BM_SETCHECK, 1, 0);

    syncBankType(hwnd, g_setup.useExternalBank);

    SendDlgItemMessage(hwnd, IDC_FLAG_SOFTPAN, BM_SETCHECK, g_setup.flagSoftPanning, 0);
    SendDlgItemMessage(hwnd, IDC_FLAG_SCALE, BM_SETCHECK, g_setup.flagScaleModulators, 0);
    SendDlgItemMessage(hwnd, IDC_FLAG_FULLBRIGHT, BM_SETCHECK, g_setup.flagFullBrightness, 0);

    SendDlgItemMessageW(hwnd, IDC_NUM_CHIPS, CB_RESETCONTENT, 0, 0);
    for(i = 1; i <= 100; i++)
    {
        ZeroMemory(buff, 10);
        snprintf(buff, 10, "%d", i);
        SendDlgItemMessageA(hwnd, IDC_NUM_CHIPS, CB_ADDSTRING, (LPARAM)0, (LPARAM)buff);
    }

    SendDlgItemMessageA(hwnd, IDC_NUM_CHIPS, CB_SETCURSEL, (WPARAM)g_setup.numChips - 1, (LPARAM)0);
    updateBankName(hwnd, g_setup.bankPath);
    SendDlgItemMessageA(hwnd, IDC_EMULATOR, CB_SETCURSEL, (WPARAM)g_setup.emulatorId, (LPARAM)0);
    SendDlgItemMessageA(hwnd, IDC_VOLUMEMODEL, CB_SETCURSEL, (WPARAM)g_setup.volumeModel, (LPARAM)0);
}

static void buildLists(HWND hwnd)
{
    int i;
    // Volume models
    for(i = 0; volume_models_descriptions[i] != NULL; ++i)
    {
        SendDlgItemMessageA(hwnd, IDC_VOLUMEMODEL, CB_ADDSTRING, (LPARAM)0, (LPARAM)volume_models_descriptions[i]);
    }

    // Emulators list
    for(i = 0; emulator_type_descriptions[i] != NULL; ++i)
    {
        SendDlgItemMessageA(hwnd, IDC_EMULATOR, CB_ADDSTRING, (LPARAM)0, (LPARAM)emulator_type_descriptions[i]);
    }
}

static void syncBankType(HWND hwnd, int type)
{
    EnableWindow(GetDlgItem(hwnd, IDC_BROWSE_BANK), type);
}

static void updateBankName(HWND hwnd, const WCHAR *filePath)
{
    int i, len = wcslen(filePath);
    const WCHAR *p = NULL;

    for(i = 0; i < len; i++)
    {
        if(filePath[i] == L'\\' || filePath[i] == L'/')
            p = filePath + i + 1;
    }

    if(p == NULL)
        SendDlgItemMessage(hwnd, IDC_BANK_PATH, WM_SETTEXT, (WPARAM)NULL, (LPARAM)L"<none>");
    else
        SendDlgItemMessage(hwnd, IDC_BANK_PATH, WM_SETTEXT, (WPARAM)NULL, (LPARAM)p);
}

static void openCustomBank(HWND hwnd)
{
    OPENFILENAMEW ofn;
    WCHAR szFile[MAX_PATH];

    ZeroMemory(&ofn, sizeof(ofn));
    ZeroMemory(szFile, sizeof(szFile));

    wcsncpy(szFile, g_setup.bankPath, MAX_PATH);

    ofn.lStructSize = sizeof(ofn);
    ofn.hInstance = s_hModule;
    ofn.hwndOwner = hwnd;
    ofn.lpstrFilter = L"WOPN bank file (*.wopn)\0*.WOPN\0All files (*.*)\0*.*\0";
    ofn.lpstrFile = szFile;
    ofn.nMaxFile = sizeof(szFile);
    ofn.lpstrTitle = L"Open external bank file";
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_READONLY | OFN_HIDEREADONLY | OFN_EXPLORER;

    if(GetOpenFileNameW(&ofn) == TRUE)
    {
        ZeroMemory(g_setup.bankPath, sizeof(g_setup.bankPath));
        wcsncpy(g_setup.bankPath, szFile, MAX_PATH);
        updateBankName(hwnd, g_setup.bankPath);
    }
}

INT_PTR CALLBACK ToolDlgProc(HWND hwnd, UINT Message, WPARAM wParam, LPARAM lParam)
{
    switch(Message)
    {
    case WM_INITDIALOG:
        buildLists(hwnd);
        syncWidget(hwnd);
        return TRUE;

    case WM_COMMAND:
        switch(LOWORD(wParam))
        {
        case IDC_ABOUT:
            MessageBoxW(hwnd,
                        L"libOPNMIDI - a software MIDI synthesizer with OPN2/OPNA FM synth,\n"
                        L"Made by Vitaly Novichkov \"Wohlstand\".\n\n"
                        L"Source code is here: https://github.com/Wohlstand/libOPNMIDI",
                        L"About this driver",
                        MB_OK);
        break;

        case IDC_NUM_CHIPS:
            if(HIWORD(wParam) == CBN_SELCHANGE)
            {
                g_setup.numChips = 1 + SendMessageW((HWND)lParam, (UINT)CB_GETCURSEL, (WPARAM)0, (LPARAM)0);
            }
            break;

        case IDC_EMULATOR:
            if(HIWORD(wParam) == CBN_SELCHANGE)
            {
                g_setup.emulatorId = SendMessageW((HWND)lParam, (UINT)CB_GETCURSEL, (WPARAM)0, (LPARAM)0);
            }
            break;

        case IDC_VOLUMEMODEL:
            if(HIWORD(wParam) == CBN_SELCHANGE)
            {
                g_setup.volumeModel = SendMessageW((HWND)lParam, (UINT)CB_GETCURSEL, (WPARAM)0, (LPARAM)0);
            }
            break;

        case IDC_BANK_INTERNAL:
            g_setup.useExternalBank = 0;
            syncBankType(hwnd, FALSE);
            break;

        case IDC_BANK_EXTERNAL:
            g_setup.useExternalBank = 1;
            syncBankType(hwnd, TRUE);
            break;

        case IDC_BROWSE_BANK:
            openCustomBank(hwnd);
            break;

        case IDC_FLAG_SOFTPAN:
            if(HIWORD(wParam) == BN_CLICKED)
            {
                g_setup.flagSoftPanning = SendDlgItemMessage(hwnd, IDC_FLAG_SOFTPAN, (UINT)BM_GETCHECK, 0, 0);
            }
            break;

        case IDC_FLAG_SCALE:
            if(HIWORD(wParam) == BN_CLICKED)
            {
                g_setup.flagScaleModulators = SendDlgItemMessage(hwnd, IDC_FLAG_SCALE, (UINT)BM_GETCHECK, 0, 0);
            }
            break;

        case IDC_FLAG_FULLBRIGHT:
            if(HIWORD(wParam) == BN_CLICKED)
            {
                g_setup.flagFullBrightness = SendDlgItemMessage(hwnd, IDC_FLAG_FULLBRIGHT, (UINT)BM_GETCHECK, 0, 0);
            }
            break;


        case IDC_RESTORE_DEFAULTS:
            setupDefault(&g_setup);
            syncWidget(hwnd);
            break;

        case IDC_RESET_SYNTH:
            sendSignal(DRV_SIGNAL_RESET_SYNTH);
            break;

        case IDC_APPLYBUTTON:
            saveSetup(&g_setup);
            sendSignal(DRV_SIGNAL_RELOAD_SETUP);
            break;

        case IDOK:
            saveSetup(&g_setup);
            sendSignal(DRV_SIGNAL_RELOAD_SETUP);
            EndDialog(hwnd, IDOK);
            break;

        case IDCANCEL:
            EndDialog(hwnd, IDCANCEL);
            break;
        }
    break;

    default:
        return FALSE;
    }

    return TRUE;

    UNREFERENCED_PARAMETER(lParam);
}


BOOL runAdlSetupBox(HINSTANCE hModule, HWND hwnd)
{
    s_hModule = hModule;

    loadSetup(&g_setup);

    DialogBoxW(hModule, MAKEINTRESOURCEW(IDD_CONFIG_BOX), hwnd, ToolDlgProc);

    s_hModule = NULL;

    return TRUE;
}

BOOL initAdlSetupBox(HINSTANCE hModule, HWND hwnd)
{
    InitCommonControls();
    setupDefault(&g_setup);
    UNREFERENCED_PARAMETER(hModule);
    UNREFERENCED_PARAMETER(hwnd);
    return TRUE;
}

BOOL cleanUpAdlSetupBox(HINSTANCE hModule, HWND hwnd)
{
    UNREFERENCED_PARAMETER(hModule);
    UNREFERENCED_PARAMETER(hwnd);
    return TRUE;
}
