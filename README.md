Simple-Dict version 0.01
========================
This is a command-line dictionary.

*ATTENTION* 
When you put a new dictionary in 'dicts', it will take some time to make index for the new one.

And you should arrange directory 'dicts' like the following configration:

	dicts/
	├── oxford
	│   ├── oxford-gb.dict
	│   ├── oxford-gb.idx
	│   └── oxford-gb.ifo
	└── stardict-langdao-ec-gb-2.4.2
	    ├── langdao-ec-gb.dict
	    ├── langdao-ec-gb.idx
	    └── langdao-ec-gb.ifo
RESOURCE
------
You can download many dictionaries from StarDict website, which are distributed with the GPL licence.

USAGE
------
In shell

    git clone https://github.com/terrencehan/Simple-Dict.git
    cd Simple-Dict/script/
    ./dict

then you will enter the dictionary shell

    word>

type the word that you want to query

    word>hello

enter, and got the result.

	hello
	牛津现代英汉双解词典
	= hallo.
	
	朗道英汉字典5.0
	*[hә'lәu]
	interj. 喂, 嘿
	
	word>

If you're not sure about the exact spelling, you can only type prefix of the word and enter, then you will be given the hint like:

	word>prefi
	     prefixing
	     prefiguration
	     prefigurative
	     prefixal
	     prefigure
	     prefix
	word>prefi

Now, you can continue to type the remaning letters.

Unfortunately, Simple-Dict don't support backspace for the letters which are typed before the hint. If you wanna cancel the typing, please enter twice.

If the result of a query is too long to display with the extent of a terminal window, you can use 'g' command to open a gvim window , if installed, for convenience.

	word>g

Command q stands for 'quit'.

	word>q

DEPENDENCIES
------------------------

This module requires these other modules and libraries:

* Moose
* File::Slurp
* File::Spec

COPYRIGHT AND LICENCE
------

Copyright (C) 2012 by terrencehan

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.
