# Helm-Charts

> [!IMPORTANT]
> These Helm charts are intended primarily for educational and personal use. They are not designed for deployment in production environments.

## Tests

### Unittests

For **unittests** we use the `helm-unittests`-Plugin.

- [https://github.com/helm-unittest/helm-unittest](https://github.com/helm-unittest/helm-unittest)

### `values.schema.json`

- [https://helm.sh/docs/topics/charts/#schema-files](https://helm.sh/docs/topics/charts/#schema-files)

### Template Checks

More complex checks if certain Values are valid to be set the way they are.
Those are defined at the `_helpers.tpl` of each Helm-Chart.
