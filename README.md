### tome.nvim

> NOT FOR USE | INCOMPLETE

Zettelkasten | the best way to save notes
Tome | the best way write notes

## The Concept

A Zettelkasten is the perfect way to keep notes, it keeps ideas seperated and linked. When writing notes however, I like to keep all the relevant topics of the study session in one file. This allows me to write and expand ideas side by side. When studying networking I don't want to move from file to file expanding upon topics. I want everything in one place.

When writing notes a Zettelkasten forces you to write, edit, organize, search, edit, write.

I want to write and edit first, organize automaticly, search later.

## The Solution

Keep everything in one file (a study session) and split the file into more files upon save for a traditional Zettelkasten.

- What if you want to work on a note that already exists?

Use autocomplete to add the note into your session file and on save it will sync with all other copies of it.

- What happens if you delete a page?

A pending deletion tag gets added to each copy in the session files.
When a page is deleted from a session file nothing will happen.

---

# Examples <!--2025-09-07-372-->

## Filetree

```
notes/
├── pages/
│   └── Sorting-Algorithms.md
│   └── Hash-Tables.md
│   └── Graph-Theory-1.md
│   └── Graph-Theory-2.md
└── sessions/
    └── DSA.md
```

## Session File

```DSA.md
# Graph Theory <!--2025-09-05-1-->

DFS vs BFS comparison...

---

# Hash Tables <!--2025-09-05-2-->


Key points from today's lecture...

---

# Sorting Algorithms <!--2025-09-05-3-->

Quick notes on bubble sort...
```

## Page File

```Graph_Theory.md
---
title: Graph Theory
date: 2025-08-31
last-edit: 2025-08-31
tags: [algorithms, cs]
---

# Graph Theory <!--2025-09-05-1-->

DFS vs BFS comparison...
```
