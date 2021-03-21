# Input Method Engine based on libpinyin for macOS

## Introduction

TODO

## Build

Run the following script in the project root directory to fetch depedencies from Homebrew Bottle:

```sh
./prepare.sh
```

The script auto-detects the arch and the OS of your Mac, downloads archives and extracts them.

It finally put libraries, data and header files into appropriate directories under this project. With no error, you should have:

- `*.bin`, `*.db` files in `data/`
- `*.a` libraries in `lib`
- `*.h` header files, which are patched for this project

Then, open `macos-libpinyin.xcodeproj` in Xcode and build it.

The app bundle should be located at `/Library/Input Methods/Debug`, move it to `/Library/Input Methods` to use it.

Do not forget to add it from the system preference panel :)
