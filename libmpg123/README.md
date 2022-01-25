This is NOT complete archive of mpg123.

Everything has been stripped down except the CMake build at the ports subdirectory.

Recommended flags to get this build (the build script at `ports/cmake` directory):

```bash
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_LIBOUT123=OFF -DBUILD_PROGRAMS=OFF -DFIFO=OFF -DNETWORK=OFF -DIPV6=OFF
```
