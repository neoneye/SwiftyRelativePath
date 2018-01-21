# SwiftyRelativePath

This is a Swift equivalent of Ruby's [`Pathname.relative_path_from()`](https://ruby-doc.org/stdlib-2.5.0/libdoc/pathname/rdoc/Pathname.html#method-i-relative_path_from)
or Java's [`Path.relativize()`](https://docs.oracle.com/javase/7/docs/api/java/nio/file/Path.html#relativize).


Example of inputs and outputs:

    | Long Path                 | Relative to Path | Return Value      |
    |---------------------------|------------------|-------------------|
    | /usr/X11/agent/47.gz      | /usr/X11         | agent/47.gz       |
    | /usr/share/man/meltdown.1 | /usr/share/cups  | ../man/meltdown.1 |
    | /var/logs/x/y/z/log.txt   | /var/logs        | x/y/z/log.txt     |



# Usage

    import SwiftyRelativePath
    
    let url0 = URL(fileURLWithPath: "/computer/qubit/17")
    let url1 = URL(fileURLWithPath: "/computer/lab")
    let path = url0.relativePath(from: url1)
    // path is "../qubit/17"


# Credits

- [Martin R](https://chat.stackoverflow.com/users/1187415/martin-r). Thank you for [your answer](https://stackoverflow.com/a/48360631/78336) on stackoverflow.
- [neoneye](https://github.com/neoneye)


# License

MIT License.
