# ScrumDown

A simple count-down timer to track the time of scrum sessions

![preview](resources/preview.gif)

## Table of content

- [Dependencies](#dependencies)
- [How to install](#how-to-install)
- [How to compile](#how-to-compile)
  - [Desktop Environment](#desktop-environment)

## Dependencies

- C++ 20
- Qt 6.7

## How to install

#### Linux/BSD

Run the installer script:

```
bash scripts/unix_build_install.sh
```

A [Desktop Environment](#desktop-environment) value can be passed as first argument:

```
bash scripts/unix_build_install.sh kde
```

#### Windows

Open a *x64 Developer Prompt* as **administrator** and run the installer script:

```
scripts\windows_build_install.bat
```

By default the linked libraries are not deployed alongside the application.
This behavior can be changed by adding the `libs` argument to the command:

```
scripts\windows_build_install.bat -libs
```

The [Desktop Environment](#desktop-environment) is automatically added by the script

## How to compile

#### Linux/BSD

```
mkdir build && cd build
qmake6 ../scrumdown -config release
make
```

#### Windows

From a *x64 Developer Prompt*, run:

```
mkdir build
cd build
qmake6 ..\scrumdown -config release
nmake
```

`jom` can be used instead of `nmake`:

```
mkdir build
cd build
qmake6 ..\scrumdown -config release
jom
```

### Desktop Environment

A _Desktop Environment_ can be specified while calling `qmake` in order to adjust some details of the graphics at compile-time and have a better feeling at run-time.

Currently supported values are:

- `gnome`
- `kde`
- `lxqt`
- `windows`

**Usage example:**

```
DESKTOP_ENVIRONMENT=gnome qmake
```
