# AutoApply

AI-powered CV customization that generates job-specific CVs, cover letters, and interview prep using [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with Chrome integration. Open a job posting in your browser, type `/apply`, and get a tailored application in seconds.

## Requirements

- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** -- CLI tool for Claude (`npm install -g @anthropic-ai/claude-code`)
- **Chrome extension** -- [Claude Code Chrome integration](https://chromewebstore.google.com/detail/claude-code-chrome-extens/iiaafbkhpcbpgpkgdnmjaihbmfkgaolf) for reading job postings from browser tabs
- **LaTeX** -- `pdflatex` for compiling CVs ([TeX Live](https://tug.org/texlive/) or [MiKTeX](https://miktex.org/))
- **pdftotext** -- for checking page breaks (`sudo apt install poppler-utils` / `brew install poppler`)

## Quick Start

```bash
# 1. Clone and enter the project
git clone <repo-url> autoapply
cd autoapply

# 2. Edit the files with your information
#    - cv.md          → Your CV content in Markdown
#    - cv.tex         → Your CV in LaTeX (matching cv.md)
#    - cover_letter_template.tex → Replace YOUR_NAME_HERE placeholders
#    - CLAUDE.md      → Fill in the "About the Candidate" section

# 3. Compile your master CV to verify LaTeX works
make cv

# 4. Start AutoApply
make autoapply

# 5. Open a job posting in Chrome, then type:
/apply
```

## Project Structure

```
├── cv.md                      # Your CV content (source of truth)
├── cv.tex                     # Your CV as LaTeX (produces the PDF)
├── cover_letter_template.tex  # Cover letter template with placeholders
├── CLAUDE.md                  # Instructions for Claude Code
├── Makefile                   # Build and launch commands
├── .claude/commands/
│   └── apply.md               # The /apply slash command
└── applications/              # Generated output (one folder per job)
    └── 2025-01-15_acme_senior-engineer/
        ├── cv.tex             # Filtered CV for this job
        ├── cv.pdf             # Compiled PDF
        ├── cover_letter.tex   # Tailored cover letter
        ├── cover_letter.pdf   # Compiled PDF
        └── analysis.md       # Skills match + interview prep
```

## How `/apply` Works

1. **Reads the job posting** from your Chrome tab (title, skills, requirements)
2. **Reads your CV** from `cv.md` and `cv.tex`
3. **Filters and tailors** -- removes irrelevant skills, condenses unrelated experience, reorders bullet points to match job requirements
4. **Generates** a filtered `cv.tex`, personalized `cover_letter.tex`, and `analysis.md` with interview prep
5. **Compiles PDFs** and checks page breaks
6. **Shows a summary** of what was kept, condensed, and removed

Your source files (`cv.md`, `cv.tex`) are never modified.

## Makefile Targets

| Command | Description |
|---------|-------------|
| `make autoapply` | Start Claude Code with Chrome integration |
| `make cv` | Compile master CV to PDF |
| `make view` | Open the compiled CV PDF |
| `make cv-app APP=folder` | Compile a specific application's CV |
| `make cv-all` | Compile all application CVs |
| `make list-apps` | List all application folders |
| `make clean` | Clean LaTeX auxiliary files |

## Tips

- **Review before sending** -- always check the generated CV and cover letter
- **cv.md is your source of truth** -- keep it comprehensive with all your experience; `/apply` handles the filtering
- **LaTeX consistency** -- `cv.tex` uses custom commands `\experienceentry` and `\skillcategory`; keep these when editing
- **analysis.md** -- use it to prep for interviews; it includes likely questions, talking points, and gap analysis

## License

MIT
