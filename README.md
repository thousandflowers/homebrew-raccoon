# homebrew-raccoon — moved

rcc lives in the tap shared by every CLI here now:

```sh
brew install thousandflowers/tap/rcc
```

If you installed from this tap you do not have to do anything. `tap_migrations.json`
moves you across on your next `brew update`, and `brew install thousandflowers/raccoon/rcc`
still works — it just resolves to the new tap.

## Why

Four projects had four taps. A tap nobody bumps keeps serving an old version
without ever saying so: the canary tap handed out shell scripts for months
after canary had become a Go binary. One tap is the only arrangement where
that cannot happen, so Raccoon's release workflow now bumps
`thousandflowers/homebrew-tap`.

MIT.
