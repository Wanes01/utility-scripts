# utility-scripts
Some utility scripts I made. Feel free to download them but keep in mind that they often solve specific problems and not general cases, so be careful how you use them.

### snake_case.sh

**<u>Description</u>**

Replaces all spaces with underscores in file and directory names from a specified path.

**<u>Syntax</u>**

```bash
./snake_case.sh [PATH] [OPTIONS]
```

- `PATH`: The directory from which the script will change the name to its child items. It can be an absolute or relative path.

- `OPTIONS`: All options can be used together; they are not mutually exclusive.

  - `-type c` specifies the type of element in which the substitution will take place.

    > If this option is omitted the default item type is directories.

    `c` can be:

    - `f` change the name only to the files
    - `d` change the name only to the directories
    - `f,d` or `d,f` change the name to both files and directories

  - `-recursive n` specifies the recursion level starting from the PATH directory

    > If this option is omitted only items directly under `PATH` will be modified (equivalent to the `-recursion 1` option)

    `n` can be:

    - An integer value greater than or equal to 1 where 1 is the directories directly under PATH
    - `max` to get to the maximum level of recursion

