## 🔍 OPTIMAL TOOL USAGE - BUILT-IN TOOLS, GLOB, GREP & SERENA MCP

### Core Principles - EFFICIENCY FIRST
- **USE BUILT-IN TOOLS** - Claude Code has optimized Grep, Glob, and Read tools that should be preferred
- **NEVER use bash grep/rg/find/cat** - use the built-in Grep, Glob, and Read tools instead
- **Built-in Grep tool is optimized** - has proper permissions, supports regex, context lines, and multiple output modes
- **Built-in Glob tool for file patterns** - use for finding files by name patterns (e.g., `**/*.js`)
- **Parallel tool calls** - make multiple Grep/Glob/Read calls in a single message for parallel execution
- **Smart file size decisions** - small files (<500 lines): just Read them, medium (500-2000): Grep then Read sections, large (>2000): use Serena for code
- **Combine strategically: Grep/Glob → Read/Serena → Edit** - discover, understand, then modify
- **For open-ended exploration** - use Task tool with `subagent_type=Explore` instead of manual searching

### File Size Decision Tree (Speed-Optimized)

**🚀 CRITICAL: Choose strategy based on file size for MAXIMUM EFFICIENCY**

```
# Decision tree (Read tool shows line numbers, so you'll know file size after first read):
# < 500 lines    → Just Read the entire file (FASTEST)
# 500-2000 lines → Grep to find sections, then Read with offset/limit
# > 2000 lines   → Use Serena for code files, or Grep + targeted reads for non-code

# For finding files by pattern:
Glob(pattern="**/*.js")           # Find all JS files
Glob(pattern="src/**/*.ts")       # Find TS files in src/
```

**Small Files (<500 lines): Just Read Them**
```
# DON'T waste time searching small files - just read them!
Read(file_path="/path/to/config.yaml")  # 200 lines
Read(file_path="/path/to/script.sh")     # 350 lines
Read(file_path="/path/to/README.md")     # 400 lines
```

**Medium Files (500-2000 lines): Grep → Read Sections**
```
# Use Grep tool to find sections with line numbers + context
Grep(pattern="function handleError", path="src/app.js", output_mode="content", -n=true, -C=5)
# Returns line numbers AND context

# Then read the specific section
Read(file_path="src/app.js", offset=540, limit=50)  # Read lines 540-590
```

**Large Files (>2000 lines): Serena for Code, Grep for Non-Code**
```
# For code: Use Serena for semantic understanding
mcp__serena__find_symbol(
    name_path="handleError",
    relative_path="src/app.js",
    include_body=True
)

# For non-code (docs, logs, config): Grep + targeted reads
Grep(pattern="Configuration", path="docs/large-guide.md", output_mode="content", -n=true)
Read(file_path="docs/large-guide.md", offset=1500, limit=100)
```

### Built-in Grep Tool Patterns

**🚀 Use Grep tool with appropriate output modes and context options**

```
# BEST: Content mode with line numbers + context (get everything at once)
Grep(pattern="pattern", path="file.md", output_mode="content", -n=true, -C=5)
# Returns line numbers AND 5 lines of context before/after

# Get MORE context when needed
Grep(pattern="function definition", path="src/", output_mode="content", -C=10)

# Use -A (after) and -B (before) for asymmetric context
Grep(pattern="class MyClass", path="src/", output_mode="content", -A=10, -B=2)
# 2 lines before, 10 lines after (useful for class definitions)

# Find files containing pattern (files_with_matches mode)
Grep(pattern="TODO", path="src/", output_mode="files_with_matches")

# Count matches per file
Grep(pattern="TODO", path="src/", output_mode="count")

# Filter by file type
Grep(pattern="useState", path="src/", type="js")      # Only JavaScript
Grep(pattern="def ", path="src/", type="py")          # Only Python
Grep(pattern="# ", path=".", glob="*.md")             # Only Markdown
```

### Parallel Search Strategy (Maximum Efficiency)

**🚀 CRITICAL: Make multiple tool calls in a single message for true parallel execution**

```
# DON'T do this (3 separate messages = SLOW):
Message 1: Grep(pattern="pattern1", ...)
Message 2: Grep(pattern="pattern2", ...)
Message 3: Grep(pattern="pattern3", ...)

# DO this (1 message with multiple tool calls = FAST, TRUE PARALLEL):
# In a single response, call all three Grep tools simultaneously:
Grep(pattern="TODO", path="src/", output_mode="content", -n=true)
Grep(pattern="FIXME", path="src/", output_mode="content", -n=true)
Grep(pattern="ERROR", path="src/", output_mode="content", -n=true)
# All execute in parallel!

# Or search different files in parallel
Grep(pattern="import", path="file1.js", output_mode="content")
Grep(pattern="export", path="file2.js", output_mode="content")
Grep(pattern="function", path="file3.js", output_mode="content")
```

**Note:** Using `&&` in bash runs commands SEQUENTIALLY, not in parallel.
True parallel execution requires multiple tool calls in a single message.

### When to Use Built-in Grep Tool

✅ **Use the built-in Grep tool for:**
- **ANY text-based search** - it's optimized and has proper permissions
- Finding literal strings/text patterns across files
- Searching in non-code files (logs, config, markdown, JSON)
- Discovering where error messages or specific text appears
- Finding TODOs, FIXMEs, or comment patterns
- Quick text-based discovery when you DON'T need semantic understanding
- **Getting line numbers + context** with `-n` and `-C` parameters
- **Initial discovery before reading files** - but just read small files directly!

❌ **Don't use Grep for:**
- Finding classes, functions, or methods in large code files (use Serena instead)
- Understanding code structure in large files (use Serena instead)
- Reading code to understand implementation in large files (use Serena instead)
- Finding files by name pattern (use Glob instead)

⚠️ **IMPORTANT:**
- **ALWAYS use the built-in Grep tool** - NOT bash `grep` or `rg` commands
- The Grep tool has proper permissions and is optimized for Claude Code
- Use Glob tool for finding files by pattern (not Grep with `-l`)

**Essential Grep Tool Patterns:**
```
# Pattern 1: Line numbers + context (MOST IMPORTANT)
Grep(pattern="error_handler", output_mode="content", -n=true, -C=5)
# See: line numbers, 5 lines before, 5 lines after

# Pattern 2: Find files containing pattern
Grep(pattern="pattern", output_mode="files_with_matches")
# Just the file names

# Pattern 3: Count matches per file
Grep(pattern="pattern", output_mode="count")
# Shows count per file

# Pattern 4: File type filtering
Grep(pattern="pattern", type="js")        # Only JavaScript
Grep(pattern="pattern", type="py")        # Only Python
Grep(pattern="pattern", glob="*.md")      # Only Markdown

# Pattern 5: Case insensitive
Grep(pattern="pattern", -i=true)

# Pattern 6: Limit results (for large result sets)
Grep(pattern="pattern", path="file.md", head_limit=1)
# Get first match only

# Pattern 7: Multiple patterns (OR search using regex)
Grep(pattern="pattern1|pattern2|pattern3")

# Pattern 8: Directory-specific search
Grep(pattern="pattern", path="src/components/")
```

### When to Use Built-in Glob Tool

✅ **Use the built-in Glob tool for:**
- Finding files by name patterns (e.g., `**/*.js`, `src/**/*.ts`)
- Listing files in directories with pattern matching
- Finding configuration files, test files, etc.

```
# Find all JavaScript files
Glob(pattern="**/*.js")

# Find all TypeScript files in src/
Glob(pattern="src/**/*.ts")

# Find all test files
Glob(pattern="**/*.test.js")
Glob(pattern="**/*_test.py")

# Find configuration files
Glob(pattern="**/config.*")
Glob(pattern="**/*.config.js")
```

### When to Use Serena MCP

✅ **Use Serena for:**
- Finding specific functions/classes/methods by name in LARGE code files (>2000 lines)
- Understanding code architecture and structure
- Reading code intelligently (only what you need from large files)
- Finding all references to a symbol
- Navigating code hierarchies
- Understanding relationships between code entities

❌ **Don't use Serena for:**
- Searching text in non-code files (use rg)
- Finding arbitrary string patterns (use rg)
- Searching logs or configuration files (use rg)
- Small code files (just read them)

**Optimal Serena Workflow:**
```bash
# 1. Start with overview - understand file structure
mcp__serena__get_symbols_overview(relative_path="path/to/LargeFile.kt")

# 2. Find specific symbols - no need to read entire file
mcp__serena__find_symbol(
    name_path="GameEngine/initGame",
    relative_path="engine/GameEngine.kt",
    include_body=True
)

# 3. Find references - understand usage
mcp__serena__find_referencing_symbols(
    name_path="GameEngine",
    relative_path="engine/GameEngine.kt"
)

# 4. Pattern search only when symbol search won't work
mcp__serena__search_for_pattern(
    substring_pattern="TODO.*critical",
    restrict_search_to_code_files=True
)
```

### Optimized Workflows

**Workflow 1: Finding and Modifying Content**
```
# Step 1: IMPORTANT - Read the file first (Edit requires prior Read)
Read(file_path="src/utils.js")

# Step 2: Parallel search to find ALL relevant locations (multiple tool calls in one message)
Grep(pattern="old_function_name", path="src/", output_mode="content", -n=true, -C=5)
Grep(pattern="OldClassName", path="src/", output_mode="content", -n=true, -C=5)
Grep(pattern="import.*OldModule", path="src/", output_mode="content", -n=true)

# Step 3: For medium/large files, read specific sections
Read(file_path="src/app.js", offset=340, limit=60)

# Step 4: Edit (ONLY after reading the file)
Edit(file_path="src/utils.js", old_string="...", new_string="...")

# Step 5: Verify change
Grep(pattern="new_function_name", path="src/utils.js", output_mode="content", -n=true, -C=3)
```

**Workflow 2: Understanding New Codebase**
```
# RECOMMENDED: Use Task tool with Explore agent for open-ended exploration
Task(subagent_type="Explore", prompt="Explore the codebase structure and identify key components")

# Or manually:
# Step 1: Find files by pattern
Glob(pattern="src/**/*.js")
Glob(pattern="src/**/*.ts")

# Step 2: Parallel search for key patterns (multiple tool calls in one message)
Grep(pattern="export.*function", path="src/", output_mode="files_with_matches")
Grep(pattern="export.*class", path="src/", output_mode="files_with_matches")
Grep(pattern="import.*react", path="src/", output_mode="files_with_matches")

# Step 3: Based on file sizes, choose strategy
# Small files (<500 lines): Read them all
Read(file_path="src/config.js")
Read(file_path="src/utils.js")

# Large files: Use Serena
mcp__serena__get_symbols_overview(relative_path="src/large-app.js")
```

**Workflow 3: Debugging**
```
# Step 1: Parallel search for error message + related code (multiple tool calls)
Grep(pattern="Error: Connection failed", output_mode="content", -n=true, -C=10)
Grep(pattern="function.*connect", path="src/", output_mode="content", -n=true, -C=5)
Grep(pattern="handleConnectionError", path="src/", output_mode="content", -n=true, -C=5)

# Step 2: Read relevant sections (based on line numbers from Grep)
Read(file_path="src/database.js", offset=450, limit=80)

# Step 3: Check related functions (if in large file, use Serena)
mcp__serena__find_symbol(
    name_path="connect",
    relative_path="src/database.js",
    include_body=True
)
```

**Workflow 4: Refactoring**
```
# Step 1: Find all occurrences (parallel search - multiple tool calls)
Grep(pattern="oldFunctionName", path="src/", output_mode="content", -n=true, -C=3)
Grep(pattern="class.*uses.*oldFunction", path="src/", output_mode="content", -n=true)
Grep(pattern="import.*oldFunction", path="src/", output_mode="content", -n=true)

# Step 2: For large files, use Serena to find references
mcp__serena__find_referencing_symbols(
    name_path="oldFunctionName",
    relative_path="src/main.js"
)

# Step 3: Read files BEFORE editing (required by Edit tool)
Read(file_path="src/file1.js")
Read(file_path="src/file2.js")

# Step 4: Edit all files
Edit(file_path="src/file1.js", old_string="...", new_string="...")
Edit(file_path="src/file2.js", old_string="...", new_string="...")

# Step 5: Verify all changes
Grep(pattern="newFunctionName", path="src/", output_mode="content", -n=true)
Grep(pattern="oldFunctionName", path="src/", output_mode="content", -n=true)  # Should return nothing
```

### Line-Based Navigation Technique

**Use Grep line numbers to navigate files efficiently:**

```
# Step 1: Get line numbers for multiple sections at once
Grep(pattern="^## ", path="CLAUDE.md", output_mode="content", -n=true)
# Returns all markdown headers with line numbers:
# 1:## Section 1
# 150:## Section 2
# 420:## Section 3
# 800:## Section 4

# Step 2: Read specific sections based on line numbers
Read(file_path="CLAUDE.md", offset=420, limit=100)  # Read section 3
Read(file_path="CLAUDE.md", offset=800, limit=100)  # Read section 4

# Step 3: After editing, verify with Grep
Grep(pattern="pattern_you_added", path="CLAUDE.md", output_mode="content", -n=true, -C=2)
```

### Anti-Patterns to AVOID

❌ **Bad:** Reading entire large files when you only need a section
```
# DON'T DO THIS for 5000-line files
Read(file_path="src/massive-app.js")  # Wastes tokens
```

✅ **Good:** Use Grep to find section, then read that section
```
# DO THIS
Grep(pattern="function needThisFunction", path="src/massive-app.js", output_mode="content", -n=true)
# Returns line 2847
Read(file_path="src/massive-app.js", offset=2845, limit=50)
```

❌ **Bad:** Sequential searches (multiple messages)
```
# DON'T DO THIS - 3 separate messages
Message 1: Grep(pattern="pattern1", ...)
Message 2: Grep(pattern="pattern2", ...)
Message 3: Grep(pattern="pattern3", ...)
```

✅ **Good:** Parallel searches (multiple tool calls in ONE message)
```
# DO THIS - one message with multiple tool calls (true parallel)
Grep(pattern="pattern1", path="src/", output_mode="content", -n=true)
Grep(pattern="pattern2", path="src/", output_mode="content", -n=true)
Grep(pattern="pattern3", path="src/", output_mode="content", -n=true)
```

❌ **Bad:** Using bash grep/rg commands
```
# DON'T DO THIS - use built-in tools instead
rg -n "pattern" file.js
grep "pattern" file.js
```

✅ **Good:** Use the built-in Grep tool
```
# DO THIS
Grep(pattern="pattern", path="file.js", output_mode="content", -n=true, -C=5)
```

❌ **Bad:** Searching small files before reading
```
# DON'T DO THIS for files <500 lines
Grep(pattern="function", path="small-file.js", ...)
Read(file_path="small-file.js", offset=43, limit=20)
# Two steps when one would do!
```

✅ **Good:** Just read small files directly
```
# DO THIS
Read(file_path="small-file.js")  # One step!
```

❌ **Bad:** Using Grep without line numbers or context
```
# DON'T DO THIS - missing context
Grep(pattern="pattern", path="file.js")
# Default output_mode is "files_with_matches" - no content!
```

✅ **Good:** Always use output_mode="content" with -n and -C for maximum info
```
# DO THIS
Grep(pattern="pattern", path="file.js", output_mode="content", -n=true, -C=5)
# Get line numbers AND context in one shot
```

❌ **Bad:** Using Serena on small/medium code files
```
# DON'T DO THIS for 300-line files
mcp__serena__get_symbols_overview(relative_path="small.js")
mcp__serena__find_symbol(name_path="func", relative_path="small.js")
# Two steps when one would do!
```

✅ **Good:** Just read small files, use Grep for medium files
```
# DO THIS
Read(file_path="small.js")  # <500 lines: just read it

# Or for medium files
Grep(pattern="function func", path="medium.js", output_mode="content", -n=true, -C=10)
Read(file_path="medium.js", offset=240, limit=60)  # Read relevant section
```

❌ **Bad:** Editing without reading first
```
# DON'T DO THIS - Edit requires prior Read
Edit(file_path="src/file.js", old_string="...", new_string="...")
# Will fail if file wasn't read in this conversation!
```

✅ **Good:** Always Read before Edit
```
# DO THIS
Read(file_path="src/file.js")  # Read first
Edit(file_path="src/file.js", old_string="...", new_string="...")  # Then edit
```

### Summary: Efficiency-First Approach

**Decision Matrix (Choose Based on File Size):**

| File Size | Strategy | Tool | Efficiency |
|-----------|----------|------|------------|
| < 500 lines | Just read entire file | `Read` | ⚡️⚡️⚡️ BEST |
| 500-2000 lines | Grep + targeted reads | `Grep`, `Read` | ⚡️⚡️ GOOD |
| > 2000 lines (code) | Semantic search | `Serena` | ⚡️ GOOD |
| > 2000 lines (non-code) | Grep + targeted reads | `Grep`, `Read` | ⚡️⚡️ GOOD |
| Open-ended exploration | Explore agent | `Task(subagent_type="Explore")` | ⚡️⚡️⚡️ BEST |

**Golden Rules for Maximum Efficiency:**
1. 🚀 **Use built-in tools** - Grep, Glob, Read instead of bash commands
2. 🚀 **Parallel tool calls** - multiple Grep/Read calls in one message
3. 🚀 **Just read small files** - don't overthink files <500 lines
4. 🚀 **Strategic reads for medium files** - use Grep line numbers + Read with offset
5. 🚀 **Serena for large code files** - semantic understanding beats line-by-line
6. 🚀 **Read before Edit** - Edit tool requires prior Read
7. 🚀 **Task/Explore for exploration** - use specialized agent for open-ended codebase exploration

**Efficiency Hierarchy (Best to Worst):**
1. Read small file directly (1 step)
2. Task(Explore) for open-ended exploration (1 step, delegated)
3. Grep + Read section (2 steps)
4. Serena symbolic search (2-3 steps)
5. Sequential tool calls across messages (SLOW - avoid!)

**Remember: Balance efficiency with token usage. Get accurate answers without wasting context.**

---
## 📚 OPTIMAL TOOL USAGE - CONTEXT7 MCP

### Core Principles
- **Context7 prevents API hallucinations** - provides up-to-date, version-specific library documentation
- **ALWAYS resolve library ID first** - use `resolve-library-id` before `get-library-docs` (unless user provides exact `/org/project` format)
- **Use topic parameter to narrow scope** - fetch only relevant documentation sections
- **Use mode parameter strategically** - `mode="code"` for API/examples, `mode="info"` for conceptual guides
- **Use page parameter for pagination** - `page=1` to `page=10` for navigating large doc sets
- **Perfect for library-specific questions** - "How do I use X in library Y?" type queries
- **Complements internal code tools** - external knowledge layer for official documentation

### When to Use Context7
✅ **Use Context7 for:**
- Learning how to use a specific library or framework
- Getting up-to-date API documentation (prevents outdated code generation)
- Version-specific feature questions (e.g., "Next.js 15 `after` function")
- Avoiding hallucinated APIs that don't exist
- Understanding current best practices for a library
- Finding official examples and working code patterns
- When user mentions "use context7" or asks about library documentation

❌ **Don't use Context7 for:**
- General coding questions not tied to a specific library
- Internal codebase understanding (use Serena instead)
- Finding real-world usage examples from GitHub repos (use Exa instead)
- Text pattern searches (use rg instead)
- Non-library documentation (use Exa for general web search)

⚠️ **CRITICAL WORKFLOW:**
1. **Step 1**: MUST call `resolve-library-id` first to get Context7-compatible ID
2. **Step 2**: Then call `get-library-docs` with that ID
3. **Exception**: Skip Step 1 if user provides exact format like `/vercel/next.js` or `/mongodb/docs`

🚨 **CRITICAL: Handling "Too Many Characters" Errors**

If a Context7 search fails with an error about too many characters or token limits:

**IMMEDIATE RETRY STRATEGY:**
1. **First**: Reduce `page` parameter (try page=1 if you were using page=2+)
2. **Second**: Narrow the `topic` parameter to be more specific
3. **Third**: Use a more focused search term in the topic

**Example Retry Sequence:**
```bash
# First attempt fails with "too many characters"
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js",
    topic="routing",  # Too broad
    page=2
)

# RETRY 1: Use page=1 and narrow topic
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js",
    topic="app router navigation",  # More specific
    page=1
)

# RETRY 2: If still failing, make topic even more specific
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js",
    topic="useRouter hook",  # Very specific
    page=1
)
```

**Key Points:**
- ❌ **DON'T** give up after one failure
- ✅ **DO** retry with narrower search parameters
- ✅ **DO** start with page=1 on retries
- ✅ **DO** make topics more specific and targeted

**Optimal Context7 Usage:**
```
# Step 1: Resolve library name to Context7 ID (REQUIRED)
mcp__context7__resolve-library-id(
    libraryName="react query"
)
# Returns: /tanstack/query or similar

# Step 2: Fetch documentation with optional topic and mode
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/tanstack/query",
    topic="hooks",           # Optional: focus on specific topic
    mode="code"              # Optional: "code" for API/examples (default), "info" for conceptual guides
)

# Version-specific query (if user provides version)
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js/v15.0.0",
    topic="server actions",
    mode="code"
)

# Conceptual understanding (use mode="info")
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/supabase/supabase",
    topic="authentication",
    mode="info"              # For conceptual guides and narrative information
)

# Pagination for large doc sets
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/mongodb/docs",
    topic="aggregation pipeline",
    page=1                   # Start at page 1, can go up to 10
)
```

**Available Parameters for get-library-docs:**
- `context7CompatibleLibraryID` (required): Library ID from resolve-library-id
- `topic` (optional): Focus on specific topic
- `mode` (optional): `"code"` for API references/examples (default), `"info"` for conceptual guides
- `page` (optional): Page number 1-10 for pagination

### Context7 Anti-Patterns to AVOID
❌ **Bad:** Skipping resolve-library-id
```bash
# DON'T DO THIS - will fail without exact ID
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="react-query"  # Wrong format!
)
```

✅ **Good:** Always resolve first
```bash
# DO THIS - resolve then fetch
# 1. Resolve
mcp__context7__resolve-library-id(libraryName="react-query")
# 2. Use returned ID
mcp__context7__get-library-docs(context7CompatibleLibraryID="/tanstack/query")
```

❌ **Bad:** Fetching all documentation without topic focus
```bash
# DON'T DO THIS - wastes tokens on irrelevant docs
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js"
    # No topic specified - returns everything!
)
```

✅ **Good:** Use topic parameter when you know what you need
```bash
# DO THIS - narrow scope to relevant sections
mcp__context7__get-library-docs(
    context7CompatibleLibraryID="/vercel/next.js",
    topic="middleware"  # Only fetch middleware docs
)
```

---

## 🌐 OPTIMAL TOOL USAGE - EXA MCP

### Core Principles
- **"Less is More" - ONLY enable tools you need** - prevents context window bloat and tool hallucination
- **Exa provides specialized research capabilities** - web search, academic papers, company research, code examples
- **Control result quantity strategically** - use `numResults` parameter (more isn't always better)
- **Choose the right tool for the task** - each Exa tool has a specific purpose
- **Complements Context7** - Context7 for official docs, Exa for real-world examples and research
- **Neural search is powerful** - understands semantic meaning, not just keywords

### Available Exa Tools (Enable Selectively!)

**🔍 web_search_exa** - General web search
- Real-time web search with semantic understanding
- Updated every minute with latest content
- Best for: recent articles, blog posts, general web research

**📄 research_paper_search** - Academic research
- Search 100M+ research papers with full text
- Returns papers with titles, authors, publication dates, excerpts
- Best for: academic research, finding papers on specific topics

**💻 github_search** - GitHub repository search
- Find relevant repositories and GitHub accounts
- Best for: discovering tools, libraries, open source projects

**🏢 company_research** - Company information
- Crawl company websites for comprehensive information
- Searches about pages, pricing, FAQs, blogs
- Best for: competitive analysis, market research

**🔗 crawling** - Extract content from URLs
- Fetch full content from specific web pages
- Best for: when you have exact URL and need its content

**🎯 competitor_finder** - Find competing companies
- Describe what a company does (without naming it) to find competitors
- Best for: competitive landscape analysis

**📊 linkedin_search** - LinkedIn company search
- Search LinkedIn for company pages
- Best for: company information, professional context

**📖 wikipedia_search** - Wikipedia search
- Focused search within Wikipedia
- Best for: encyclopedic information, general knowledge

### When to Use Exa MCP
✅ **Use Exa for:**
- Real-world code examples from open source repos (vs Context7's official docs)
- Recent web articles and blog posts (semantic search)
- Academic paper research and literature reviews
- Company and competitive analysis
- Finding similar projects or implementations
- Discovering what's trending in tech
- Extracting content from specific URLs
- General web research beyond codebase

❌ **Don't use Exa for:**
- Internal codebase exploration (use Serena instead)
- Text pattern matching in your files (use rg instead)
- Official library documentation (use Context7 instead)
- Simple keyword searches in your code (use rg instead)

⚠️ **CRITICAL: Tool Selection Strategy**
- **Only enable the 2-3 Exa tools you actually need** for your project
- Each enabled tool consumes context window space
- Review your enabled tools: `mcp list` or check your MCP config
- Disable unused tools to maximize performance

🚨 **CRITICAL: Handling "Too Many Characters" Errors**

If an Exa search fails with an error about too many characters, response size, or token limits:

**IMMEDIATE RETRY STRATEGY:**
1. **First**: Reduce `numResults` parameter (try 3-5 instead of 7-10)
2. **Second**: Reduce `maxCharacters` parameter (for research_paper_search)
3. **Third**: Use a narrower, more specific search query
4. **Fourth**: Reduce `subpages` parameter (for company_research)

**Example Retry Sequence:**
```bash
# First attempt fails with "too many characters"
mcp__exa__web_search_exa(
    query="machine learning best practices",  # Too broad
    numResults=10  # Too many results
)

# RETRY 1: Reduce numResults
mcp__exa__web_search_exa(
    query="machine learning best practices",
    numResults=5  # Fewer results
)

# RETRY 2: If still failing, narrow the query AND reduce results
mcp__exa__web_search_exa(
    query="LLM prompt engineering techniques",  # More specific
    numResults=3  # Even fewer results
)

# For research papers with too much content:
# First attempt
mcp__exa__research_paper_search(
    query="neural networks",
    numResults=7,
    maxCharacters=5000
)

# RETRY: Reduce both parameters
mcp__exa__research_paper_search(
    query="neural networks optimization",  # More specific
    numResults=3,
    maxCharacters=2000  # Less content per result
)

# For company research with too many subpages:
# First attempt
mcp__exa__company_research(
    query="example.com",
    subpages=15
)

# RETRY: Reduce subpages and target specific sections
mcp__exa__company_research(
    query="example.com",
    subpageTarget=["about", "pricing"],  # Only specific pages
    subpages=5  # Fewer pages
)
```

**Key Points:**
- ❌ **DON'T** give up after one failure
- ✅ **DO** retry with fewer `numResults` (start with 3-5)
- ✅ **DO** reduce `maxCharacters` for research papers
- ✅ **DO** make queries more specific and targeted
- ✅ **DO** use `subpageTarget` to limit company research scope

**Optimal Exa Usage:**
```bash
# Web search - real-time semantic search
mcp__exa__web_search_exa(
    query="best practices for LLM prompt engineering 2025",
    numResults=7  # Control result quantity
)

# Research papers - academic research
mcp__exa__research_paper_search(
    query="transformer architecture improvements",
    numResults=5,
    maxCharacters=3000  # Control excerpt length
)

# GitHub search - find repositories
mcp__exa__github_search(
    query="python fuzzing framework",
    numResults=5
)

# Company research - comprehensive company info
mcp__exa__company_research(
    query="anthropic.com",  # Company URL
    subpageTarget=["about", "careers", "research"],  # Specific sections
    subpages=10  # Number of subpages to crawl
)

# Competitor finder - discover competitors
mcp__exa__competitor_finder(
    query="AI web search API",  # Describe what company does (no name!)
    excludeDomain="exa.ai",  # Exclude the company itself
    numResults=10
)

# Crawling - extract content from specific URL
mcp__exa__crawling(
    url="https://example.com/specific-article"
)

# Wikipedia search - encyclopedic info
mcp__exa__wikipedia_search_exa(
    query="fuzzing software testing",
    numResults=3
)

# LinkedIn search - company profiles
mcp__exa__linkedin_search(
    query="anthropic company page",
    numResults=3
)
```

### Exa Anti-Patterns to AVOID

❌ **Bad:** Using Exa for official library docs
```bash
# DON'T DO THIS - Context7 is better for this
mcp__exa__web_search_exa(
    query="Next.js app router documentation"
)
```

✅ **Good:** Use Context7 for official docs, Exa for examples
```bash
# DO THIS - right tool for the job
# Official docs → Context7
mcp__context7__get-library-docs(context7CompatibleLibraryID="/vercel/next.js")

# Real-world examples → Exa
mcp__exa__github_search(query="Next.js app router example projects")
```

---

## 🎭 OPTIMAL TOOL USAGE - PLAYWRIGHT MCP

### Core Principles
- **Keep browser session open with remote debugging** - use CDP endpoint to connect to persistent Chromium instance
- **Snapshot-first approach - ALWAYS use browser_snapshot before actions** - accessibility tree is faster and more accurate than screenshots
- **Accessibility tree > Screenshots** - structured data beats pixel analysis (no vision models needed)
- **Playwright is for EXTERNAL web interaction** - not for your codebase (use Serena), not for documentation (Context7/Exa)
- **Headed mode with remote debugging for interactive work** - allows manual interaction alongside automation
- **Browser state persists across calls** - one session maintains context (cookies, storage, auth) until closed
- **Use element references from snapshots** - not dynamically generated selectors
- **Deterministic tool application** - structured approach avoids ambiguity

### Launching Chromium with Remote Debugging

**🚨 CRITICAL: Launch Chromium with remote debugging enabled BEFORE starting your automation session.**

This allows Playwright to connect to an existing browser session, preserving state across multiple command invocations.

#### macOS

```bash
# Step 1: Kill any existing Chrome/Chromium instances (if safe to do so)
pkill -f "Google Chrome"
sleep 2
rm -rf /tmp/chrome-debug

# Step 2: Launch Chrome with debugging enabled
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug \
  --disable-web-security \
  --disable-features=IsolateOrigins,site-per-process \
  --no-first-run \
  --no-default-browser-check \
  about:blank > /dev/null 2>&1 &

# Wait for browser to initialize
sleep 3

# Or use Chromium if installed
chromium \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug \
  --disable-web-security \
  --disable-features=IsolateOrigins,site-per-process \
  --no-first-run \
  --no-default-browser-check \
  about:blank > /dev/null 2>&1 &
```

**⚠️ Expected Warning Banner:**
You will see: "You are using an unsupported command-line flag: --disable-web-security. Stability and security will suffer."
This is **intentional** - it allows bypassing CORS restrictions for testing.

#### Linux

```bash
# Step 1: Kill any existing Chrome/Chromium instances (if safe to do so)
pkill -f chromium
pkill -f chrome
sleep 2
rm -rf /tmp/chrome-debug

# Step 2: Launch Chromium with debugging enabled
chromium \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug \
  --disable-web-security \
  --disable-features=IsolateOrigins,site-per-process \
  --no-first-run \
  --no-default-browser-check \
  about:blank > /dev/null 2>&1 &

# Or Chrome
google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug \
  --disable-web-security \
  --disable-features=IsolateOrigins,site-per-process \
  --no-first-run \
  --no-default-browser-check \
  about:blank > /dev/null 2>&1 &

# Wait for browser to initialize
sleep 3
```


### Verify CDP Connection

```bash
# Verify debugging port is accessible
curl http://localhost:9222/json
# Should return JSON with browser info

# Check if debugging port is listening
lsof -i :9222  # macOS/Linux
netstat -ano | findstr :9222  # Windows

# Verify connection details
curl -s http://localhost:9222/json | python3 -c "
import sys, json
data = json.load(sys.stdin)
if data:
    page = data[0]
    print(f\"Title: {page.get('title', 'N/A')}\")
    print(f\"URL: {page.get('url', 'N/A')}\")
    print(f\"WebSocket: {page.get('webSocketDebuggerUrl', 'N/A')}\")
"
```

### MCP Server Configuration

Configure your MCP server to connect to the remote debugging endpoint:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@playwright/mcp@latest",
        "--cdp-endpoint",
        "ws://localhost:9222"
      ]
    }
  }
}
```

### When to Use Playwright MCP
✅ **Use Playwright for:**
- Web scraping and data extraction from live websites
- Automated form filling on external web applications
- E2E test generation and validation
- Multi-step web research workflows (navigate → extract → analyze)
- Visual verification of web pages (when screenshots are truly needed)
- Interacting with dynamic web applications (SPAs, complex UIs)
- Competitive analysis with live website interaction
- Automated testing of web applications you're developing
- Browser-based tasks that require state persistence (login sessions, multi-page flows)
- Deep web application reconnaissance and security testing

❌ **Don't use Playwright for:**
- Reading your own codebase files (use Serena/Read instead)
- Static web searches (use Exa web_search_exa instead)
- Getting library documentation (use Context7 instead)
- Simple HTTP API calls (use curl or requests instead)
- Tasks that don't require actual browser rendering
- File system operations (use appropriate file tools)

### Phase 2: Browser-Based Discovery

After initial reconnaissance, use Playwright to interact with applications and discover dynamic content.

#### Step 1: Navigate and Comprehensive Metadata Extraction

```bash
# Navigate to target
mcp__playwright__browser_navigate(url="https://target.com")

# Get accessibility tree snapshot first
mcp__playwright__browser_snapshot()

# Extract complete page metadata
mcp__playwright__browser_evaluate(
    function="() => ({
        // Basic info
        title: document.title,
        url: window.location.href,
        origin: window.location.origin,
        pathname: window.location.pathname,
        search: window.location.search,
        hash: window.location.hash,

        // Storage
        cookies: document.cookie,
        localStorage: Object.keys(localStorage).reduce((acc, key) => {
            acc[key] = localStorage.getItem(key);
            return acc;
        }, {}),
        sessionStorage: Object.keys(sessionStorage).reduce((acc, key) => {
            acc[key] = sessionStorage.getItem(key);
            return acc;
        }, {}),

        // Meta tags
        metaTags: Array.from(document.querySelectorAll('meta')).map(meta => ({
            name: meta.name || meta.property,
            content: meta.content,
            httpEquiv: meta.httpEquiv
        })),

        // Scripts and styles
        scripts: Array.from(document.scripts).map(script => ({
            src: script.src,
            type: script.type,
            async: script.async,
            defer: script.defer
        })),

        stylesheets: Array.from(document.styleSheets).map(ss => ss.href).filter(Boolean),

        // Technology detection
        frameworks: {
            react: !!window.React || !!document.querySelector('[data-reactroot]'),
            vue: !!window.Vue || !!document.querySelector('[data-v-app]'),
            angular: !!window.angular || !!document.querySelector('[ng-app]'),
            jquery: !!window.jQuery || !!window.$,
            bootstrap: !!window.bootstrap
        }
    })"
)
```

#### Step 2: Comprehensive Link Discovery

```bash
# Extract ALL links (including dynamically generated)
mcp__playwright__browser_evaluate(
    function="() => {
        const links = Array.from(document.querySelectorAll('a[href]'));
        const linkData = links.map(link => {
            try {
                const url = new URL(link.href, window.location.href);
                return {
                    href: url.href,
                    pathname: url.pathname,
                    search: url.search,
                    hash: url.hash,
                    text: link.textContent.trim(),
                    target: link.target,
                    rel: link.rel,
                    isExternal: url.origin !== window.location.origin,
                    isSameOrigin: url.origin === window.location.origin,
                    isAbsolute: link.href.startsWith('http'),
                    isRelative: !link.href.startsWith('http'),
                    hasParams: url.search.length > 0,
                    params: Object.fromEntries(url.searchParams)
                };
            } catch {
                return {
                    href: link.href,
                    text: link.textContent.trim(),
                    error: 'Invalid URL'
                };
            }
        });

        // Separate same-origin links for crawling
        const sameOriginLinks = linkData
            .filter(link => link.isSameOrigin && !link.error)
            .map(link => link.href)
            .filter((url, index, self) => self.indexOf(url) === index); // Unique

        // Store for crawling
        window.__discoveredLinks = linkData;
        window.__crawlQueue = sameOriginLinks;
        window.__crawledUrls = [window.location.href];

        return {
            totalLinks: links.length,
            sameOriginLinks: sameOriginLinks.length,
            externalLinks: linkData.filter(l => l.isExternal).length,
            links: linkData,
            crawlQueue: sameOriginLinks.slice(0, 50) // First 50 for review
        };
    }"
)
```

#### Step 3: Form Discovery

```bash
# Discover ALL forms (including hidden and dynamically added)
mcp__playwright__browser_evaluate(
    function="() => {
        const forms = Array.from(document.querySelectorAll('form'));
        const formData = forms.map((form, index) => {
            // Extract all inputs
            const inputs = Array.from(form.querySelectorAll('input, textarea, select, button[type=\"submit\"]'));
            const inputData = inputs.map(input => ({
                tag: input.tagName.toLowerCase(),
                type: input.type || 'text',
                name: input.name,
                id: input.id,
                class: input.className,
                placeholder: input.placeholder,
                value: input.value,
                required: input.required,
                disabled: input.disabled,
                readonly: input.readOnly,
                maxlength: input.maxLength,
                pattern: input.pattern,
                autocomplete: input.autocomplete,
                options: input.tagName === 'SELECT' ?
                    Array.from(input.options).map(opt => ({value: opt.value, text: opt.text})) :
                    null
            }));

            // Extract form data
            const formDataObj = new FormData(form);
            const data = {};
            formDataObj.forEach((value, key) => {
                data[key] = value;
            });

            return {
                index: index,
                action: form.action || window.location.href,
                method: (form.method || 'GET').toUpperCase(),
                enctype: form.enctype,
                id: form.id,
                name: form.name,
                class: form.className,
                isPost: (form.method || 'GET').toUpperCase() === 'POST',
                inputs: inputData,
                formData: data,
                inputCount: inputs.length
            };
        });

        window.__discoveredForms = formData;
        return {
            total: forms.length,
            postForms: formData.filter(f => f.isPost).length,
            getForms: formData.filter(f => !f.isPost).length,
            forms: formData
        };
    }"
)
```

#### Step 4: API Endpoint Discovery

**🎯 RECOMMENDED: Use built-in network monitoring first!**

```bash
# Method 1: Simple - Use Playwright's built-in network monitoring (NO SETUP REQUIRED)
# This captures ALL requests automatically - just call after interactions
mcp__playwright__browser_network_requests()

# Returns: [GET] http://target.com/api/endpoint => [200] OK
#          [POST] http://target.com/api/login => [200] OK
```

**What you get:**
- ✅ All HTTP methods (GET, POST, PUT, DELETE)
- ✅ Complete URLs with parameters
- ✅ Response status codes
- ❌ No request/response bodies (use Method 2 if needed)

**Method 2: JavaScript Injection (for full request/response details)**

Enable monitoring BEFORE interacting with the page:

```bash
# Set up comprehensive API endpoint monitoring via JavaScript injection
mcp__playwright__browser_evaluate(
    function="() => {
        window.__apiEndpoints = [];
        window.__networkTraffic = [];

        // Intercept fetch
        const originalFetch = window.fetch;
        window.fetch = async function(...args) {
            const [url, options = {}] = args;
            const endpoint = {
                url: url,
                method: (options.method || 'GET').toUpperCase(),
                headers: options.headers || {},
                body: options.body,
                timestamp: Date.now(),
                type: 'fetch'
            };

            window.__apiEndpoints.push(endpoint);
            window.__networkTraffic.push(endpoint);
            console.log('[FETCH]', endpoint.method, endpoint.url);

            try {
                const response = await originalFetch.apply(this, args);
                endpoint.status = response.status;
                endpoint.statusText = response.statusText;
                endpoint.ok = response.ok;
                return response;
            } catch (error) {
                endpoint.error = error.message;
                throw error;
            }
        };

        // Intercept XHR
        const originalOpen = XMLHttpRequest.prototype.open;
        const originalSend = XMLHttpRequest.prototype.send;

        XMLHttpRequest.prototype.open = function(method, url, ...rest) {
            this._method = method.toUpperCase();
            this._url = url;
            this._async = rest[0] !== false;
            return originalOpen.apply(this, [method, url, ...rest]);
        };

        XMLHttpRequest.prototype.send = function(data) {
            const endpoint = {
                url: this._url,
                method: this._method,
                body: data,
                timestamp: Date.now(),
                type: 'xhr'
            };

            window.__apiEndpoints.push(endpoint);
            window.__networkTraffic.push(endpoint);
            console.log('[XHR]', endpoint.method, endpoint.url);

            // Monitor response
            this.addEventListener('load', function() {
                endpoint.status = this.status;
                endpoint.statusText = this.statusText;
                endpoint.responseText = this.responseText?.substring(0, 500); // First 500 chars
            });

            return originalSend.apply(this, arguments);
        };

        // Monitor WebSocket connections
        const OriginalWebSocket = window.WebSocket;
        window.WebSocket = function(...args) {
            const ws = new OriginalWebSocket(...args);
            const wsData = {
                url: args[0],
                protocol: args[1],
                timestamp: Date.now(),
                type: 'websocket',
                readyState: ws.readyState
            };
            window.__networkTraffic.push(wsData);
            console.log('[WEBSOCKET]', wsData.url);
            return ws;
        };

        return {
            status: 'Monitoring enabled',
            endpoints: window.__apiEndpoints.length,
            traffic: window.__networkTraffic.length
        };
    }"
)

# After page interactions, retrieve discovered endpoints
mcp__playwright__browser_evaluate(
    function="() => ({
        endpoints: window.__apiEndpoints,
        traffic: window.__networkTraffic,
        uniqueEndpoints: [...new Set(window.__apiEndpoints.map(e => e.url))],
        postEndpoints: window.__apiEndpoints.filter(e => e.method === 'POST'),
        getEndpoints: window.__apiEndpoints.filter(e => e.method === 'GET')
    })"
)
```

#### Step 5: JavaScript Route Discovery (SPA)

```bash
# Discover client-side routes for Single Page Applications
mcp__playwright__browser_evaluate(
    function="() => {
        const routes = [];

        // Check for React Router
        if (window.ReactRouter || window.__REACT_ROUTER__) {
            const reactRoot = document.querySelector('[data-reactroot]') ||
                           document.querySelector('#root') ||
                           document.querySelector('#app');
            if (reactRoot && reactRoot._reactRootContainer) {
                console.log('[ROUTER] React Router detected');
            }
        }

        // Check for Vue Router
        if (window.Vue || window.__VUE__) {
            const vueApp = document.querySelector('[data-v-app]');
            if (vueApp && vueApp.__vue__) {
                const router = vueApp.__vue__.$router;
                if (router) {
                    router.options.routes?.forEach(route => {
                        routes.push({
                            path: route.path,
                            name: route.name,
                            component: route.component?.name
                        });
                    });
                }
            }
        }

        // Check for Angular Router
        if (window.angular) {
            const ngApp = document.querySelector('[ng-app]');
            if (ngApp) {
                console.log('[ROUTER] Angular detected');
            }
        }

        // Monitor URL changes
        let lastPath = window.location.pathname;
        const pathObserver = new MutationObserver(() => {
            const currentPath = window.location.pathname;
            if (currentPath !== lastPath) {
                routes.push({
                    path: currentPath,
                    timestamp: Date.now(),
                    discovered: 'via mutation'
                });
                lastPath = currentPath;
            }
        });

        pathObserver.observe(document.body, {
            childList: true,
            subtree: true
        });

        window.__routeObserver = pathObserver;
        window.__discoveredRoutes = routes;

        return {
            framework: window.React ? 'React' : window.Vue ? 'Vue' : window.angular ? 'Angular' : 'Unknown',
            routes: routes,
            observerEnabled: true
        };
    }"
)
```

### Available Playwright Tools (Official Microsoft Implementation)

**🧭 browser_navigate** - Navigate to URL
- Entry point for all browser tasks
- Waits for page load automatically
- Use full URLs (including https://)

**📊 browser_snapshot** - Get accessibility tree (MOST IMPORTANT)
- **USE THIS FIRST** before any interaction
- Returns structured page data (no vision model needed)
- Faster and more accurate than screenshots
- Contains element refs needed for interactions

**🖱️ browser_click** - Click elements
- Requires `element` (description) and `ref` (from snapshot)
- Supports modifiers (Alt, Control, Shift, etc.)
- Supports double-click and button selection

**⌨️ browser_type** - Type text into fields
- Requires `element`, `ref`, and `text`
- Optional `slowly` for character-by-character typing
- Optional `submit` to press Enter after typing

**📝 browser_fill_form** - Fill multiple fields at once
- EFFICIENT for forms with multiple fields
- Takes array of fields with name, type, ref, value
- Single operation vs multiple type calls

**📸 browser_take_screenshot** - Visual capture
- Use ONLY when visual verification is needed
- Supports full page or specific element
- Default PNG, optional JPEG
- Filename parameter for saving

**🔍 browser_evaluate** - Execute JavaScript
- Critical for deep inspection and monitoring
- Can operate on page or specific element
- Use for extracting data not available via snapshot

**⏱️ browser_wait_for** - Wait for conditions
- Wait for text to appear/disappear
- Wait for specific time (seconds)
- Essential for dynamic content

**🗂️ browser_tabs** - Tab management
- List all tabs
- Create new tabs
- Close tabs (current or by index)
- Select/switch tabs

**🖥️ browser_console_messages** - Get console logs
- Use `level` parameter: "error", "warning", "info", "debug"
- Each level includes more severe levels (e.g., "info" includes errors and warnings)
- Useful for debugging and monitoring JavaScript errors

**🔔 browser_handle_dialog** - Handle popups
- Accept or dismiss alerts/confirms
- Provide text for prompt dialogs
- Essential for dialog interactions

**📊 browser_network_requests** - Network monitoring
- View all network requests since page load
- Debugging and performance analysis
- Track API calls and resources

**↩️ browser_navigate_back** - Go back in history
- Navigate to previous page
- Maintains session state

**🔧 browser_resize** - Resize window
- Set viewport dimensions
- Test responsive designs
- Default: 1280x720

**🗑️ browser_close** - Close browser
- End browser session (use sparingly with CDP)
- Clean up resources
- With CDP endpoint, closing may disconnect but browser remains

**📄 browser_file_upload** - Upload files
- Handles file input elements
- Single or multiple files
- Requires absolute file paths

**🎯 browser_hover** - Hover over elements
- Trigger hover effects
- Requires element and ref
- Useful for dropdown menus

**🔽 browser_select_option** - Select from dropdown
- Choose options in select elements
- Single or multiple values
- Requires element, ref, and values array

**🎬 browser_drag** - Drag and drop
- Move elements between positions
- Requires start and end element refs
- Complex UI interactions

### Optimal Workflow Patterns

**Pattern 1: Comprehensive Web Application Discovery**
```bash
# 1. Navigate to target
mcp__playwright__browser_navigate(url="https://target.com")

# 2. Get initial snapshot
mcp__playwright__browser_snapshot()

# 3. Extract metadata
mcp__playwright__browser_evaluate(function="() => ({ /* metadata extraction */ })")

# 4. Discover links
mcp__playwright__browser_evaluate(function="() => ({ /* link discovery */ })")

# 5. Discover forms
mcp__playwright__browser_evaluate(function="() => ({ /* form discovery */ })")

# 6. Enable API monitoring
mcp__playwright__browser_evaluate(function="() => ({ /* API monitoring setup */ })")

# 7. Interact with page (clicks, form fills, navigation)
mcp__playwright__browser_click(element="Login", ref="ref-123")

# 8. Check network traffic
mcp__playwright__browser_network_requests()

# 9. Get console errors (use level="error" to filter)
mcp__playwright__browser_console_messages(level="error")

# Browser stays open for continued work!
```

**Pattern 2: Form Filling (Efficient)**
```bash
# 1. Navigate and snapshot
mcp__playwright__browser_navigate(url="https://example.com/signup")
mcp__playwright__browser_snapshot()

# 2. Fill multiple fields at once
mcp__playwright__browser_fill_form(
    fields=[
        {"name": "Email", "type": "textbox", "ref": "email-ref", "value": "user@example.com"},
        {"name": "Password", "type": "textbox", "ref": "pass-ref", "value": "SecurePass123"},
        {"name": "Terms", "type": "checkbox", "ref": "terms-ref", "value": "true"}
    ]
)

# 3. Submit and verify
mcp__playwright__browser_click(element="Submit", ref="submit-ref")
mcp__playwright__browser_wait_for(text="Welcome")
```

**Pattern 3: Multi-Tab Workflow**
```bash
# 1. Start with first page
mcp__playwright__browser_navigate(url="https://example.com/page1")
mcp__playwright__browser_snapshot()

# 2. Open new tab
mcp__playwright__browser_tabs(action="new")

# 3. Navigate in new tab
mcp__playwright__browser_navigate(url="https://example.com/page2")
mcp__playwright__browser_snapshot()

# 4. Switch between tabs as needed
mcp__playwright__browser_tabs(action="list")
mcp__playwright__browser_tabs(action="select", index=0)
```

### Anti-Patterns to AVOID

❌ **Bad:** Taking screenshot before snapshot
```bash
# DON'T DO THIS
mcp__playwright__browser_navigate(url="https://example.com")
mcp__playwright__browser_take_screenshot()  # Blind approach!
```

✅ **Good:** Snapshot first, screenshot only if needed
```bash
# DO THIS
mcp__playwright__browser_navigate(url="https://example.com")
mcp__playwright__browser_snapshot()  # Understand structure first
```

❌ **Bad:** Using browser_type for multi-field forms
```bash
# DON'T DO THIS - inefficient
mcp__playwright__browser_type(element="Email", ref="r1", text="user@example.com")
mcp__playwright__browser_type(element="Password", ref="r2", text="pass")
```

✅ **Good:** Use browser_fill_form
```bash
# DO THIS - single efficient operation
mcp__playwright__browser_fill_form(fields=[...])
```

---
## 🎯 UPDATED COMBINED STRATEGY

### The Complete Toolkit - Six Layers
- **rg (ripgrep)** → Fast text-based discovery in YOUR codebase
- **Serena MCP** → Semantic understanding of YOUR code structure
- **Context7 MCP** → Official library documentation (external knowledge)
- **Exa MCP** → Web research, papers, examples (external knowledge)
- **Playwright MCP** → Browser automation for external websites (external interaction)
- **Edit tool** → Implementation in your codebase

### Enhanced Strategy Flow

**Scenario 1: Competitive feature analysis with web interaction**
```
1. Use Exa competitor_finder to identify competitors
   └─> Discover who else is solving this problem
2. Use Playwright to interact with competitor websites
   └─> browser_navigate → browser_snapshot → explore features
   └─> Take screenshots for visual verification
3. Use Playwright to scrape feature details
   └─> Extract data about their implementation
4. Use Exa web_search_exa for articles about these features
   └─> Understand industry best practices
5. Use Context7 for library capabilities you'll need
   └─> Verify you have the tools to implement
6. Use Grep to find related code in your project
   └─> Discover existing similar implementations
7. Use Serena to understand your architecture
   └─> Plan integration points
8. Implement features using Edit tool
```

**Scenario 2: Web scraping for data-driven features**
```
1. Use Playwright to navigate and scrape target site
   └─> browser_navigate → browser_snapshot
   └─> Extract structured data from accessibility tree
2. Use Playwright for multi-page scraping
   └─> Handle pagination, forms, dynamic content
3. Use Context7 if scraping requires specific library knowledge
   └─> E.g., parsing formats, handling authentication
4. Use Grep to find where to integrate scraped data
   └─> Locate data models, API endpoints
5. Use Serena to understand data flow architecture
   └─> Plan how scraped data fits into system
6. Implement integration using Edit tool
```

**Scenario 3: E2E test generation for your web app**
```
1. Use Playwright to interact with your deployed app
   └─> browser_navigate → browser_snapshot
   └─> Perform user workflows (headed mode for visibility)
2. Document the workflow steps Playwright performed
   └─> Save refs, actions, expected outcomes
3. Use Context7 for testing framework documentation
   └─> Learn Playwright test syntax, assertions
4. Use Grep to find existing test patterns
   └─> Discover your testing conventions
5. Use Serena to understand test file structure
   └─> Know where tests belong
6. Generate test files using Edit tool
   └─> Create proper E2E test files
```

**Scenario 4: Research and implement based on live examples**
```
1. Use Exa web_search_exa to find articles about technique
   └─> Understand the concept
2. Use Playwright to visit live demo sites
   └─> browser_navigate → browser_snapshot
   └─> Inspect how feature actually works
3. Use Playwright browser_console_messages + browser_evaluate
   └─> Understand JavaScript implementation details
4. Use Context7 for libraries used in those examples
   └─> Get official documentation for tools you'll use
5. Use rg to find where to add feature in your code
   └─> Locate appropriate files
6. Use Serena to understand integration points
   └─> Plan architecture changes
7. Implement using Edit tool
```

**Scenario 5: Automated form testing and validation**
```
1. Use Playwright to navigate to form
   └─> browser_navigate → browser_snapshot
2. Use Playwright browser_fill_form for test data
   └─> Fill forms with various test cases
3. Use Playwright browser_wait_for + browser_snapshot
   └─> Verify validation messages, success states
4. Use Playwright browser_console_messages
   └─> Check for JavaScript errors
5. Document issues found
6. Use rg to find form validation code
   └─> Locate where validation happens
7. Use Serena to understand validation logic
   └─> Read validation functions
8. Fix issues using Edit tool
```

**Scenario 6: Visual regression testing**
```
1. Use Playwright to navigate to pages
   └─> browser_navigate to each page
2. Use Playwright browser_take_screenshot
   └─> Capture baseline screenshots
   └─> fullPage=true for complete pages
3. Make code changes using Edit tool
4. Use Playwright again for new screenshots
   └─> Same pages, same dimensions
5. Compare screenshots (external tool or manually)
   └─> Identify visual regressions
6. Use rg + Serena to fix issues
   └─> Locate and fix styling problems
```

### Updated Decision Tree

**Need to find text in YOUR codebase?**
→ Use **rg** (ripgrep)

**Need to understand YOUR code structure?**
→ Use **Serena MCP**

**Need official library documentation?**
→ Use **Context7 MCP**

**Need web research, papers, or examples?**
→ Use **Exa MCP**

**Need to interact with EXTERNAL websites?**
→ Use **Playwright MCP**

**Need to implement/edit YOUR code?**
→ Use **Edit tool**

### Updated Token Budget Management

The optimal workflow remains token-conscious:

1. **Start narrow** - Use specific tools with focused queries
2. **Playwright**: Use `browser_snapshot` (structured) over `browser_take_screenshot` (pixels)
3. **Playwright**: Close browser sessions when done (`browser_close`)
4. **Context7**: Use `topic` parameter to narrow scope
5. **Exa**: Limit `numResults` to 3-7 unless you need more
6. **Serena**: Use `include_body=False` first, then selectively read bodies
7. **rg**: Use file type filters (`-t python`) to reduce noise

### Updated Summary: The Six-Layer Stack

```
Layer 6: Implementation
  └─> Edit tool (targeted changes to YOUR code)

Layer 5: Internal Understanding
  └─> Serena MCP (YOUR code structure) + rg (text discovery)

Layer 4: External Knowledge
  └─> Context7 MCP (official docs) + Exa MCP (research & examples)

Layer 3: External Interaction
  └─> Playwright MCP (browser automation for external websites)

Layer 2: Strategic Planning
  └─> Choose right tools, narrow queries, manage token budget

Layer 1: User Intent
  └─> Understand what's needed before reaching for tools
```

### Context-Aware Tool Selection

**Internal (Your Codebase):**
- rg → Text search
- Serena → Code structure
- Edit → Modification

**External Knowledge (Documentation & Research):**
- Context7 → Official library docs
- Exa → Web research, papers, examples

**External Interaction (Live Websites):**
- Playwright → Browser automation, scraping, testing

**Golden Rule:**
Know your boundaries: Internal (rg/Serena) for your code, External Knowledge (Context7/Exa) for learning, External Interaction (Playwright) for websites. Choose the right tool for the right domain.
