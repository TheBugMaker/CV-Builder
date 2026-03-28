# AutoApply - CV Customization with Claude Code
# Usage: make autoapply

.PHONY: cv clean cleanall view help
.PHONY: cv-app cv-all view-app list-apps clean-apps
.PHONY: autoapply

# Colors
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Show this help message
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

# =============================================================================
# AutoApply - Claude CV Customization
# =============================================================================

define AUTOAPPLY_PROMPT
You are a senior hiring manager specializing in CV optimization. \
When /apply is invoked: \
1. READ the job posting from Chrome browser tab \
2. READ cv.md, cv.tex, and cover_letter_template.tex (NEVER modify originals) \
3. FILTER content - REMOVE irrelevant items, KEEP only job-relevant skills/experience \
4. GENERATE in applications/{date}_{company}_{role}/: cv.tex (filtered LaTeX), cover_letter.tex (using template), analysis.md \
5. COMPILE PDFs with pdflatex (both cv.tex and cover_letter.tex). \
RULES: Never fabricate experience. Use exact LaTeX commands from cv.tex. Filter to 1-2 pages max.
endef
export AUTOAPPLY_PROMPT

autoapply: ## Start Claude for CV customization
	@echo "$(GREEN)AutoApply - CV Customization$(NC)"
	@echo "1. Open a job posting in Chrome"
	@echo "2. Type /apply when ready"
	@echo ""
	claude --chrome \
		--model opus \
		--append-system-prompt "$$AUTOAPPLY_PROMPT" \
		--allowedTools "Read,Write,Bash(mkdir:*),Bash(pdflatex:*),Bash(date:*),Bash(pdftotext:*)" \
		--strict-mcp-config \
		--mcp-config '{"mcpServers":{}}'

# =============================================================================
# CV Compilation
# =============================================================================

cv: cv.pdf ## Compile CV to PDF

cv.pdf: cv.tex
	pdflatex -interaction=nonstopmode cv.tex
	pdflatex -interaction=nonstopmode cv.tex  # Run twice for references

view: cv.pdf ## View the CV PDF
	xdg-open cv.pdf 2>/dev/null || open cv.pdf 2>/dev/null || echo "PDF created: cv.pdf"

# =============================================================================
# Application-specific CV Compilation
# =============================================================================

cv-app: ## Compile CV for a specific application (usage: make cv-app APP=folder-name)
	@if [ -z "$(APP)" ]; then \
		echo "Usage: make cv-app APP=<folder-name>"; \
		echo ""; \
		echo "Available applications:"; \
		ls -1 applications/ 2>/dev/null || echo "  No applications yet"; \
		exit 1; \
	fi
	@if [ ! -f "applications/$(APP)/cv.tex" ]; then \
		echo "Error: applications/$(APP)/cv.tex not found"; \
		exit 1; \
	fi
	@echo "Compiling CV for $(APP)..."
	cd applications/$(APP) && pdflatex -interaction=nonstopmode cv.tex
	cd applications/$(APP) && pdflatex -interaction=nonstopmode cv.tex
	@echo ""
	@echo "$(GREEN)Done!$(NC) PDF created: applications/$(APP)/cv.pdf"

cv-all: ## Compile all application CVs
	@echo "Compiling all application CVs..."
	@found=0; \
	for dir in applications/*/; do \
		if [ -f "$$dir/cv.tex" ]; then \
			found=1; \
			echo "Compiling $$dir..."; \
			(cd "$$dir" && pdflatex -interaction=nonstopmode cv.tex > /dev/null && \
			 pdflatex -interaction=nonstopmode cv.tex > /dev/null) || \
			echo "  $(YELLOW)Warning: Failed to compile $$dir$(NC)"; \
		fi \
	done; \
	if [ $$found -eq 0 ]; then \
		echo "No applications with cv.tex found"; \
	else \
		echo "$(GREEN)Done!$(NC)"; \
	fi

view-app: ## View CV for a specific application (usage: make view-app APP=folder-name)
	@if [ -z "$(APP)" ]; then \
		echo "Usage: make view-app APP=<folder-name>"; \
		exit 1; \
	fi
	@if [ ! -f "applications/$(APP)/cv.pdf" ]; then \
		echo "Error: applications/$(APP)/cv.pdf not found"; \
		echo "Run 'make cv-app APP=$(APP)' first"; \
		exit 1; \
	fi
	xdg-open applications/$(APP)/cv.pdf 2>/dev/null || open applications/$(APP)/cv.pdf 2>/dev/null

list-apps: ## List all application folders
	@echo "Applications:"
	@if [ -d "applications" ] && [ "$$(ls -A applications 2>/dev/null)" ]; then \
		for dir in applications/*/; do \
			name=$$(basename "$$dir"); \
			if [ "$$name" != "*" ]; then \
				if [ -f "$$dir/cv.pdf" ]; then \
					echo "  $(GREEN)$$name$(NC) (compiled)"; \
				elif [ -f "$$dir/cv.tex" ]; then \
					echo "  $(YELLOW)$$name$(NC) (not compiled)"; \
				else \
					echo "  $$name (no cv.tex)"; \
				fi \
			fi \
		done; \
	else \
		echo "  No applications yet"; \
	fi

# =============================================================================
# Cleanup
# =============================================================================

clean: ## Clean auxiliary files
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz

clean-apps: ## Clean auxiliary files from all applications
	@echo "Cleaning application auxiliary files..."
	@find applications -name "*.aux" -delete 2>/dev/null || true
	@find applications -name "*.log" -delete 2>/dev/null || true
	@find applications -name "*.out" -delete 2>/dev/null || true
	@echo "Done"

cleanall: clean ## Clean everything including CV PDF
	rm -f cv.pdf
