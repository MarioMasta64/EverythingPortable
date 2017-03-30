# EverythingPortable

release v2 yay

allows downloading binaries from my repositories (all things ive released)

allows removing binaries

all binaries can coexist in harmony

all binaries are now easier to use

binaries now have options to download needed .dll files (specificly for obs portable)

now includes downloader option in all my other projects

Known Issues:

these are not meant to be ran from the root of your drive as %CD% will break when written to .vbs files

Example:

%CD%\bin\test > test.vbs

will write \<drive\>:\\\\bin\test to test.vbs which will NOT work (i have workarounds but i honestly dont see a reason for these to be ran from a root of a drive)

Reason:

%CD% sees a longpath as F:\\test\\test

but %CD% sees root as F:\\

the extra \\ at the end messes it up

Example:

version.txt isnt read from suite (easy fix)

updates on mobile (hard)
