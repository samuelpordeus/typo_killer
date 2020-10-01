# Typo Killer
### _qu'est que ce_
![CI badge](https://github.com/samuelpordeus/typo_killer/workflows/Elixir%20CI/badge.svg)

#### Building

With elixir installed, open `typo_killer` folder and use the following commands
on your terminal:

```
mix deps.get
mix compile
```

#### Simple Usage

**Using iex**

Open an iex session:

```
iex -S mix
```

Then just: `TypoKiller.find_typos("path/to/folder")`

**Using mix**

Just run `mix typo_killer path/to/folder`

#### Creating a binary

This will create a self contained executable file which will include everything
that you need to run TypoKiller. This file can be distributed to other people
and they don't need to have an Erlang runtime installed - it's all in the
binary file.

To create it, run:

```
mix escript.build
```

This will generate an executable file `bin/typokiller`. Now run
`./bin/typokiller --help` for more information.

#### Installing on a POSIX system

```Bash
$ make
$ sudo make install
```

Then you can use it like:

```
$ typokiller --help
```

#### Typo Killer on the wild

Are you using Typo Killer on big repos? Send a PR adding it here! :slightly_smiling_face:
- [Elixir](https://github.com/elixir-lang/elixir/pull/9611)
- [Ecto](https://github.com/elixir-ecto/ecto/pull/3174)
- [Phoenix](https://github.com/phoenixframework/phoenix/pull/3623)
- [Devise](https://github.com/plataformatec/devise/pull/5167)
- [Simple Form](https://github.com/heartcombo/simple_form/pull/1681)
- [Rails](https://github.com/rails/rails/pull/38238)

### Documentation

You can generate the documentation using command `mix docs`

#### Contributing
Feel free to suggest some new features or report bugs creating a new issue. Or even better, you can open a pull request! 😄
