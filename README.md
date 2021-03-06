#ype Emacs.D

My dotemacs a sometimes dirty, sometimes beautiful heap of defuns and
party hats that gets me from point A to B and sometimes a little bit
further.

The files available in this repo usually reside in my `~/.emacs.d`
folder. It is also worth noting the file entitled `init-elpa` - which
has been wonderfully made by @purcell, and handles package
installation and updates through Emacs Package manager. I should add
that beyond the init-elpa file, a lot of inspiration for my dotemacs
comes from Steve Purcell's
[emacs.d](https://github.com/purcell/emacs.d) and random hacks from
countless blogs.

If you use this config, I recommend first loading Emacs without any
changes made to the config files given here - this will let you see
how the packages get installed and how the config I have hacked
together from multiple sources actually works.

To use this config, drop the `init` folder in your .emacs.d folder,
you can then either use my init.el, or add the parts you want (note:
that `init-elpa` and `init-site-lisp` are required by the setup -
however if you don&rsquo;t want to use these files, you can switch the
`require-package` macro out for just plain old `require`. Also, you
should change `after-load` to standard elisp `eval-after-load`

If you have problems using it I am more then glad to help, and you can
drop me a note in the
[issues](https://github.com/ype/emacs.d/issues?page=1&state=open) for
this repo.

I should also mention that I sometimes write about the different
little tweaks I have done to my dotemacs and you can find those @
[ype.env.sh](http://ype.env.sh)

---

**ype**
