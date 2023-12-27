# Hyperscan

Hyperscan is a high-performance multiple regex matching library. It follows the
regular expression syntax of the commonly-used libpcre library, but is a
standalone library with its own C API.

Hyperscan uses hybrid automata techniques to allow simultaneous matching of
large numbers (up to tens of thousands) of regular expressions and for the
matching of regular expressions across streams of data.

Hyperscan is typically used in a DPI library stack.

# About this fork

I am looking for a fast C++ replacement for `std::regex`. Hyperscan is a promising candidate, 
as is `re2`. I wasn't able to find a trustworthy distribution of Hyperscan headers/DLLs, nor 
was I able to build it from source out-of-the-box. So I tweaked the build logic for Windows until
I had a working native build (e.g. not Cygwin, MinGW, etc).

The maintainers of Hyperscan don't seem to be accepting PRs, based on the queue in GitHub. So
rather than try to upstream, I made this fork. And I cherry-picked a few PRs that looked important,
adding them here and linking back to the source.

If you want to build Hyperscan from source, you're in the right place.

## Building this fork

I run builds using Visual Studio. If you don't have it, you can download the [Build Tools for Visual Studio](https://visualstudio.microsoft.com/downloads/?q=build+tools#build-tools-for-visual-studio-2022) installer to get the command-line tools for free.

You'll also need Ninja and a few other things. Read the Hyperscan docs to learn more.

1. Open a VS command shell, or open a normal shell and run `vcvars64`.

2. Prepare the CMake build environment.

```
cmake -G Ninja -B build\x64\debug -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Debug
```

Build types are `Debug`, `Release`, and `MinSizeRel`. You can also enable support for additional hardware instructions like AVX2 and AVX512. Here's an example:

```
cmake -G Ninja -B build\x64-avx2\release -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=/arch:AVX2 -DCMAKE_CXX_FLAGS=/arch:AVX2
```

3. Run the build

```
ninja -C build\x64\debug
```

4. Make sure tests pass

```
build\x64\debug\bin\unit-hyperscan.exe
```

## One thing you should know: Ragel dependency

Hyperscan builds rely on a state machine compiler named [Ragel](https://www.colm.net/open-source/ragel). Ragel takes annotated C++ files (.rl) and emits buildable C++ files (.cpp), replacing annotations with real state-machine code. I couldn't find a binary distro of Ragel that worked on Windows, nor was I able to get it building from source. 
So I cheated. I ran Ragel from Ubuntu using the Windows Subsystem for Linux, and merged the output .cpp files into the
source tree as .rl.cpp files. Then I expanded the build system to recognize these, and use them instead of running Ragel.

This means I'm taking on the maintenance burden of regenerating whenever the .rl files change. I can live with that.

Regeneration steps:

1. Install Windows Subsystem for Linux.

```
wsl --install -d Ubuntu
```

2. Log in, and update the APT catalog.

```
sudo apt update
```

3. Install Ragel 6.9 (6.10 seems to work too).

```
sudo apt install ragel
```

4. Navigate to your Hyperscan git repo on the Windows side, and run ragel-gen.sh.

```
cd /mnt/c/Users/afoxman/source/repos/hyperscan
./ragel-gen.sh
```

5. Look at the git diffs to confirm that the '%%' annotations in the .rl files were replaced by a bunch of machine-generated code.


# Documentation

Information on building the Hyperscan library and using its API is available in
the [Developer Reference Guide](http://intel.github.io/hyperscan/dev-reference/).

# License

Hyperscan is licensed under the BSD License. See the LICENSE file in the
project repository.

# Versioning

The `master` branch on Github will always contain the most recent release of
Hyperscan. Each version released to `master` goes through QA and testing before
it is released; if you're a user, rather than a developer, this is the version
you should be using.

Further development towards the next release takes place on the `develop`
branch.

# Get Involved

The official homepage for Hyperscan is at [www.hyperscan.io](https://www.hyperscan.io).

If you have questions or comments, we encourage you to [join the mailing
list](https://lists.01.org/mailman/listinfo/hyperscan). Bugs can be filed by
sending email to the list, or by creating an issue on Github.

If you wish to contact the Hyperscan team at Intel directly, without posting
publicly to the mailing list, send email to
[hyperscan@intel.com](mailto:hyperscan@intel.com).
