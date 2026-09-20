---
name: release-firewall-multi
description: Prepare, validate, tag, and publish this firewall_multi Puppet module to Puppet Forge, or diagnose a failed release. Use for release and publication requests in this repository.
---

# Release firewall_multi

Use GitHub Actions as the normal publishing path. Read `metadata.json`,
`Rakefile`, `.github/workflows/release.yaml`, `.github/workflows/build.yaml`,
`.README.erb`, and `CHANGELOG` first; these are authoritative if they differ
from this guidance.

Follow the user's scope and existing authorization. Preparing a release does
not authorize publishing it; a request to release and publish authorizes the
tag push without another confirmation. Writing this skill does not authorize
a release.

## Prepare

- Check the working tree, branch, remotes, and tags. The canonical repository
  is `alex-harvey-z3q/puppet-firewall_multi`; the Forge module is
  `alexharvey-firewall_multi`. These account names intentionally differ.
- Fetch origin and reconcile upstream changes without discarding user work.
  Keep unrelated changes out of the release commit.
- Determine the intended version from the request and metadata. A correction
  to an already-published release, including metadata, needs a new version.
  Do not overwrite a Forge release or move an existing published tag.
  Module and upstream versions need not always match.
- Update the version in `metadata.json`, prepend a dated `CHANGELOG` entry,
  and add a compatibility row in `.README.erb`. Update version-specific release
  examples there too. Regenerate `README.md` with `bundle exec rake docs`;
  do not edit generated documentation directly.
- Check BOTH bounds of the firewall dependency against actual compatibility.
  The release check expects `>= FIRST <= LAST` from the first and last upstream
  versions in the latest README matrix row. The manifest generated for firewall
  8.4.0 exposes `ctmask`, `nfmask`, and `restore_mark`; its documented range is
  `>= 8.4.0 <= 8.4.0`, not a range starting at 8.0.1. Do not broaden the upper
  bound without verification.
- For upstream feature updates, inspect the intended upstream release and
  regenerate `manifests/init.pp` using `gen_params.sh`. The generator reads
  `../puppetlabs-firewall` directly. Inspect that checkout's status and revision
  first, and preserve user changes. The Rake variable `PUPPETLABS_FIREWALL_DIR`
  does not redirect the generator's hardcoded path.

## Validate and commit

Use Ruby from `.ruby-version`, with `rbenv exec` where appropriate. Install the
bundle and lint tools, including ShellCheck and yamllint. On macOS the generator
needs Homebrew GNU sed. Mirror CI bundle settings: exclude acceptance gems for
build checks, but include them for local Litmus tests.

1. Run `bundle exec rake docs` and review the release changes.
2. Run `bundle exec rake ci:build`. This includes validation, lint, RSpec,
   documentation, dependency audit, package installation, and manifest checks.
   Do not suppress audit findings just to release. Fixtures install firewall
   from Forge without pinning it, so green tests alone do not prove that the
   declared minimum version works.
3. Run non-tag release checks:
   `bundle exec rake release:version_matrix release:changelog release:readme_version release:os_support`.
   OS support is compared with the upstream checkout. CI clones upstream HEAD
   if that directory is absent; diagnose upstream drift when checks disagree.
4. Check `git diff --check`, commit the scoped changes with a meaningful
   multiline message, and push the release commit when authorized.
5. Verify the build workflow succeeds for this exact commit, including both
   Ruby/Puppet matrix entries and Litmus acceptance. Find runs using
   `gh run list --commit COMMIT_SHA`. If running acceptance locally, ensure
   Docker is available and always run `bundle exec rake ci:acceptance_teardown`
   after `bundle exec rake ci:acceptance`, even on failure. Report which checks
   actually ran; release checks alone are not the full suite.

## Tag and publish

The Release workflow triggers on pushed `X.Y.Z` tags without a `v` prefix.
It runs release checks and `bundle exec rake module:push`; it does not wait
for the build workflow or run the full test suite itself.

1. Derive the version rather than copying an old example:
   `release_version=$(ruby -rjson -e 'puts JSON.parse(File.read("metadata.json")).fetch("version")')`.
2. Confirm the release commit is clean and tested, and the version is unused
   locally, remotely, and on Forge. After committing, create the local tag:
   `git tag "$release_version"`. If resuming a release with an existing tag,
   verify its target and publication state instead of recreating it.
3. Run `bundle exec rake release:check` before pushing the tag. The tag check
   uses the latest local tag by creator date, so a new release needs its local
   tag first. Separately verify it points at the tested commit: the Rake check
   does not establish this. Leave the tag unpushed if checks fail.
4. Confirm repository secrets `BLACKSMITH_FORGE_USERNAME` and
   `BLACKSMITH_FORGE_API_KEY` are configured. Inspect names, not values. The
   workflow uses `https://forgeapi.puppet.com`. Do not print credentials or read
   shell secret files merely to check configuration.
5. When publication is authorized, push only the intended tag:
   `git push origin "refs/tags/$release_version"`. Do not use `git push --tags`.
6. Find and monitor the Release run for this tag and commit; inspect failed
   job logs. Verify the published version and dependencies at
   `https://forgeapi.puppet.com/v3/releases/alexharvey-firewall_multi-VERSION`
   and `https://forge.puppet.com/modules/alexharvey/firewall_multi`.
   A successful git push alone is not proof of publication.

If publication fails or its outcome is uncertain, check Forge before retrying.
Rerun only a diagnosed, recoverable failure for the intended version. Do not
repeatedly upload, delete releases, or move remote tags. Report blockers and
the current tag, workflow, and Forge state. Prefer fixing workflow issues over
silently switching to local publication. Use local Blacksmith publication only
when requested, isolating the intended package from stale files in `pkg/`.

Finish with the commit, tag, test results, workflow link, Forge publication
status, and any remaining blocker. Include the commit message after changes.
