# Fenster

Pass a small, fixed-size "window" over a list, making edits within that window based on its contents.

  * After lexing, you might want to combine adjacent tokens,
    such as `space, line comment, newline, newline` → `newline`.
  * In an optimizaer you might change `call foo; ret` → `tailcall foo`.
  * In cleaning up a document, you might need to merge two adjacent lists together.
