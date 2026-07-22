# Changelog

Entries for releases up to 0.3.0 are back-filled from git history and
rubygems.org release dates, so early entries are best-effort summaries.

## 0.3.0 — 2026-05-13

- Normalize legacy ids that include a subject class before querying the API
  (`math.DG/0510097` → `math/0510097`) — the API returns empty results for the
  subject-class form, though the website still redirects it.
- Fix specs broken by arxiv API drift: PDF link position in the Atom `link`
  list, `https://` link URLs, and MSC classes no longer being returned for
  legacy manuscripts.
- Remove stale code from `Manuscript`.

## 0.2.0 — 2026-05-13

- Guard against missing manuscript fields with safe navigation when a
  lookup returns no results.

## 0.1.11 — 2024-04-30

- Stop appending `.pdf` to `Manuscript#pdf_url` — arxiv no longer serves the
  extensioned URL form.
- CI: test against multiple Ruby versions.

## 0.1.10 — 2022-06-23

- Replace `Kernel#open` with `URI.open` (removes a command-injection hazard
  and a Ruby 3 deprecation).

## 0.1.9 — 2022-04-29

- README wording updates. No library changes.

## 0.1.8 — 2022-04-28

- Repository housekeeping. No library changes.

## 0.1.7 — 2022-04-25

- Move CI and gem publishing to GitHub Actions. No library changes.

## 0.1.6 — 2017-10-01

- Add `Author#first_name` and `Author#last_name`, split from the full name
  via `full-name-splitter`.

## 0.1.5 — 2016-10-04

- Force PDF URLs to use SSL.

## 0.1.4 — 2016-10-04

- Force arxiv URLs to use SSL.

## 0.1.3 — 2015-09-28

- Use the Atom `updated` field for `Manuscript#updated_at`.

## 0.1.2 — 2015-09-25

- CI deployment configuration. No library changes.

## 0.1.1 — 2015-09-23

- Loosen the id format constraint to accept newer arxiv ids (5-digit
  sequence numbers, e.g. `1509.06369`).

## 0.1.0 — 2015-09-23

- Upgrade to RSpec 3.
- Fix `Category#long_description` bugs.
- Constrain gem dependency versions.
- Gemspec cleanup and CircleCI setup.

## 0.0.8 — 2013-03-28

- Repository housekeeping. No library changes.

## 0.0.7 — 2013-02-07

- Force a `.pdf` extension on `Manuscript#pdf_url`.

## 0.0.6 — 2012-03-04

- Don't cache `Category.types` until first use.

## 0.0.5 — 2012-02-16

- Minor fixes.

## 0.0.4 — 2012-02-15

- Add support for legacy manuscript ids (e.g. `math/0510097`).

## 0.0.3 — 2012-02-14

- `Arxiv.get` accepts a full arxiv URL in addition to a document id.

## 0.0.2 — 2012-02-14

- Better error handling: `Arxiv::Error::ManuscriptNotFound` and
  `Arxiv::Error::MalformedId`.

## 0.0.1 — 2012-02-14

- Initial release, extracted from Scholastica: `Arxiv.get` plus the
  `Manuscript`, `Author`, `Category`, and `Link` models.
