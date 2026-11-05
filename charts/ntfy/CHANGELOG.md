# CHANGELOG for `charts/ntfy`

## `0.2.0` to `0.3.0`

> [!CAUTION]
> When using the Helm chart's `AppVersion` instead of a custom defined `.Values.ntfyContainer.image.tag`-Version-tag, you should keep in mind that this upgrade comes with a big container-image Version-jump from `v2.26.0` to `v2.37.2`.
>
> Please, at least take a look at [github.com/binwiederhier/ntfy/releases](https://github.com/binwiederhier/ntfy/releases) before upgrading, when using the default container-image repository and version-tag.

* Update Chart-AppVersion to `v2.37.2`

## `0.1.6-alpha` to `0.2.0`

> [!CAUTION]
> **Breaking changes**: This upgrade includes Helm-Values changes that are not backwards-compatible!

