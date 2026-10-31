# Evidence

**Evidence** is a screenshot, a GIF, or a video that shows one scenario of the ticket in the running product. Each piece has a caption with the expected result and the actual result. Capture it after the last ensemble call, so that it shows the head SHA that `create-pr` receives.

## Pick the recorder

1. If the session has device tools or browser tools that record, use them. Follow the `Steps:` of the scenario.
2. Otherwise, if the test tool of the scenario can record, such as Playwright video, use it.
3. Otherwise, write `no evidence: <reason>` in the manifest row of the scenario. Continue the run, because the test result of the scenario still counts.

A `manual` scenario gets no evidence. Its row in the results table is `NEEDS_HUMAN`.

## Pick the kind

For each `Then` and `And` line, ask: can one frame show this result?

| Kind                  | Use when                                                                   | Example                                                  |
| --------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------- |
| Screenshot            | One frame shows the result.                                                | The list shows `qa@example.com` with the status Pending. |
| GIF or MP4            | The result is a change over time, or it depends on the order of the steps. | A page turn, a navigation, a scroll, a loading state.    |
| Before and after pair | The scenario changes a screen that exists on the base commit.              | The same screen on the base commit and on the branch.    |

1. If a clip is shorter than 15 seconds, convert it to a GIF with `ffmpeg`. Otherwise, keep the MP4.
2. Take each before screenshot in a second worktree at the base commit. Remove that worktree after the capture.

## Write the caption

1. For **Expected**, copy the `Then` or `And` line word for word.
2. For **Actual**, open the screenshot, or one frame of the video, and write what you see. Do not copy the test result, because a test can pass on the wrong screen. To get a frame, run `ffmpeg -ss <seconds> -i <video> -frames:v 1 <frame>.png`.
3. If Actual differs from Expected, mark the scenario `FAIL` in the results table, even if its test passes.

## Store the files

1. Put each file in `.evidence/` at the root of the worktree.
2. Add `.evidence/` to `$(git rev-parse --git-common-dir)/info/exclude`, because screenshots and videos in a commit make the repository larger.
3. Write `.evidence/manifest.md`, with one row for each piece of evidence:

<manifest-template>

| Scenario | Kind | File | Expected | Actual |
| -------- | ---- | ---- | -------- | ------ |

</manifest-template>

The kind is `screenshot`, `before`, `after`, `gif`, or `mp4`.

**Done when:** each `automated` scenario has a manifest row with a file, or a row with `no evidence: <reason>`.
