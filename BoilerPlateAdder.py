# updates the copyright information for all .cs files
# usage: call recursive_traversal, with the following parameters
# parent directory, old copyright text content, new copyright text content

import os
import codecs

exclude_dir = []


def update_source(filename, old_copyright, copyright):
    utf_str = chr(0xef) + chr(0xbb) + chr(0xbf)
    f_data = codecs.open(filename, "r+").read()
    isUTF = False
    if f_data.startswith(utf_str):
        isUTF = True
        f_data = f_data[3:]
    if old_copyright is not None:
        if f_data.startswith(old_copyright):
            f_data = f_data[len(old_copyright):]
    if not (f_data.startswith(copyright)):
        print("updating " + filename)
        f_data = copyright + f_data
        if isUTF:
            codecs.open(filename, "w").write(utf_str + f_data)
        else:
            codecs.open(filename, "w").write(f_data)


def recursive_traversal(dir, oldcopyright, copyright):
    global exclude_dir
    fns = os.listdir(dir)
    print("listing " + dir)
    for fn in fns:
        full_fn = os.path.join(dir, fn)
        if full_fn in exclude_dir:
            continue
        if os.path.isdir(full_fn):
            recursive_traversal(full_fn, oldcopyright, copyright)
        else:
            if full_fn.endswith(".m"):
                update_source(full_fn, oldcopyright, copyright)


# oldcright = codecs.open("oldcr.txt", "r+").read()
oldcright = ''
cright = codecs.open("LicenseBoilerPlate.txt", "r+").read()
recursive_traversal(".", oldcright, cright)
exit()
