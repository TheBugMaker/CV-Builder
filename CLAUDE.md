# AutoApply

CV customization system that generates job-specific CVs using Claude Code with Chrome integration.

## About the Candidate

> **Edit this section with your personal information before using AutoApply.**

- **Name**: [Your Name]
- **Role**: [Your Role / Title]
- **Location**: [Your City, Country]
- **Specializations**: [Your key areas of expertise]

## Project Structure

```
├── cv.md                  # Source CV content (READ ONLY - never modify during /apply)
├── cv.tex                 # LaTeX template (READ ONLY - never modify during /apply)
├── cover_letter_template.tex  # Cover letter template
├── cv.pdf                 # Compiled master CV
├── applications/          # Output folder for job-specific CVs
│   └── {date}_{company}_{role}/
│       ├── cv.tex         # Filtered LaTeX for this job
│       ├── cv.pdf         # Compiled PDF
│       ├── cover_letter.tex
│       ├── cover_letter.pdf
│       └── analysis.md
├── Makefile
└── .claude/commands/
    └── apply.md           # The /apply slash command
```

## Key Commands

- `/apply` - Generate customized CV for job posting in browser
- `make cv` - Compile master cv.tex to PDF
- `make cv-app APP=folder` - Compile specific application's CV
- `make list-apps` - List all application folders

## Important Rules

1. **NEVER modify cv.md or cv.tex** - These are the source files
2. **FILTER content** - Remove irrelevant sections, don't just reorder
3. **Match LaTeX format** - Output must use same commands as cv.tex
4. **Never fabricate** - Only include actual experience and skills
5. **Use job keywords** - But only if they genuinely apply

## LaTeX Template Reference

The cv.tex file uses these custom commands:
- `\experienceentry{Title}{Dates}{Company, Location}{}` - For job entries
- `\skillcategory{Category}{Skills}` - For skill sections
- Standard sections: Summary, Technical Skills, Professional Experience, Side Projects, Education, Certifications, Languages

## Output Guidelines

When generating cv.tex for applications:
- Keep same document structure and styling
- Filter skills to only those relevant to the job
- Condense or remove irrelevant experience bullet points
- Aim for 1-2 pages maximum
- Preserve all LaTeX formatting and commands
