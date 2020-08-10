# Cut Release Tag

This GitHub Action watches the `VERSION` file, and if the tag with the same name does not exist yet, create one.

## Usage

### Requirements

This action expects

- `VERSION` file exists at root directory of a repository
- `VERISON` file contains only SemVer string

### Inputs

- `force`: Replace an existing tag (default: `false`)
- `message`: Tag message, `__VERSION__` will replace its version number (default: `release __VERSION__`)
- `only_major_version`: Use only major version (default: `false`)
- `prefix`: Prefix for release tag (default: `v`)
- `suffix`: Suffix for release tag (default: `''`)

### Outputs

- `tag`: Name for release tag

## Example workflow

The following example will create `v1.0.0` tag at GitHub repository.  
**(IMPORTANT)** If you want to trigger this tagging event, you need to set a personal access token instead of `secrets.GITHUB_TOKEN` (see: [About workflow events](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#about-workflow-events)).

```bash
$ cat VERSION
1.0.0
```

```yaml
    steps:
      - uses: actions/checkout@v2
        with:
          token: ${{ secrets.PERSONAL_TOKEN }}
      - uses: kobtea/release-tag-action@v0
```

The following example will create `v1` tag, such a stable release.
Every time this step is triggered, this `v1` tag will override.

```yaml
    steps:
      - uses: actions/checkout@v2
        with:
          token: ${{ secrets.PERSONAL_TOKEN }}
      - uses: kobtea/release-tag-action@v0
        with:
          force: true
          only_major_version: true
```

For more example, see below.

- https://github.com/kobtea/release-tag-action/blob/master/.github/workflows/tag.yml
- https://github.com/kobtea/release-tag-action/blob/master/.github/workflows/release.yml
