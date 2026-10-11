# 🚀 Nexus AgenticAI: Skill & Job Analysis Platform

A production-oriented, multi-agent AI platform built from scratch to conduct adaptive diagnostic scenario assessments, evaluate engineering maturity using rubric-grounded LLM graders, compute deterministic mathematical job compatibility fit, and generate autonomous upskilling micro-curriculums with dynamic re-test score boosts.

---

## 🏗️ Architecture & Multi-Agent State Machine

The platform runs as a coordinated multi-agent state machine powered by Google Gemini (`gemini-2.5-flash` for real-time interview turns; `gemini-2.5-pro` for deep grading and roadmap generation):

```
┌────────────────────────────────────────────────────────────────────────┐
│                        CANDIDATE INTERFACE                             │
│       React 18 + Vite + Tailwind CSS + Lucide + Recharts Radar         │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ REST API
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                         NODE.JS / EXPRESS                              │
│                                                                        │
│   ┌────────────────────────┐         ┌───────────────────────────────┐ │
│   │ 1. Diagnostic Agent    │         │ 2. Skill Evaluator Agent      │ │
│   │ State 0: Turn 1 (Init) │         │ • Full Transcript Ingestion   │ │
│   │ State 1: Evaluate &    │         │ • Rubric-grounded 0-10 Matrix │ │
│   │          Adapt Diff.   │ ──────► │ • Verified Strengths & Gaps   │ │
│   │ State 2: Terminate     │         │ • Readiness Tier Grading      │ │
│   │ (gemini-2.5-flash)     │         │ (gemini-2.5-pro)              │ │
│   └────────────────────────┘         └───────────────┬───────────────┘ │
│                                                      │                 │
│                                                      ▼                 │
│   ┌────────────────────────┐         ┌───────────────────────────────┐ │
│   │ 4. Autonomous Roadmap  │         │ 3. Job Matching Engine        │ │
│   │    & Coach Agent       │ ◄────── │ • Algorithmic Fit Score       │ │
│   │ • 3-Stage Curriculum   │ Recalc  │   Skill Ratio = min(1.0, S/R) │ │
│   │ • Interactive Re-Tests │ Matches │   Job Match % = Σ(W*SR) / Σ(W)│ │
│   │ • Dynamic Score Boosts │         │ • AI Analysis Layer (Verdicts)│ │
│   └────────────────────────┘         └───────────────────────────────┘ │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        PERSISTENT DATA STORE                           │
│  users • assessment_sessions • skill_profiles • job_benchmarks • roadmaps
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Database Collections & Schemas

The backend uses a thread-safe, file-backed JSON database store in `backend/data/`:

1. **`users`**: Candidate profile, target roles, career stage, and timestamp.
2. **`assessment_sessions`**:
   - `session_id`, `user_id`, `domain` (`Full Stack`, `Backend Systems`, `Frontend Architecture`, `AI/ML Engineering`, `Cloud & DevOps`, `Data Engineering`), `status` (`in_progress`, `completed`).
   - `transcript`: Array of `[{ question_id, turn_index, difficulty, topic, question_text, user_answer, feedback, timestamp }]`.
3. **`skill_profiles`**:
   - Stored after the evaluator finishes. Holds the JSON skill matrix (scores 0–10, verified levels, reasoning), verified strengths, critical gaps, overall readiness tier, and executive summary.
4. **`job_benchmarks`**:
   - Curated standard job profiles with required skill weights ($W_i$) and minimum proficiency thresholds ($R_i$).
5. **`roadmaps`**:
   - Generated 3-stage micro-curriculums (`Concept`, `Hands-on Task`, `Re-test Trigger`), user solutions, and verification score boosts.

---

## 🧮 Mathematical Fit Score Formula

For any benchmark job $J$ requiring skills $S_1, S_2, \dots, S_n$ with minimum required scores $R_i$ and importance weights $W_i$:

$$\text{Skill Ratio}_i = \min\left(1.0, \frac{\text{User Score}_i}{R_i}\right)$$

$$\text{Job Match \%} = \left(\frac{\sum (W_i \times \text{Skill Ratio}_i)}{\sum W_i}\right) \times 100$$

### AI Analysis Layer
- **Ready to Apply (80%+)**: Highlights where candidate scenario answers directly proved senior competence.
- **Upskilling Needed (50–79%)**: Identifies the 2–3 blocking gaps (e.g., Cache stampede prevention, PostgreSQL lock contention, PgBouncer pooling).
- **Fundamental Gaps (<50%)**: Highlights prerequisite foundational engineering tracks.

---

## 🎯 4-View Dashboard Experience

1. **Dashboard Home**:
   - Overall Readiness Tier & Competency footprint.
   - Interactive Recharts Radar Chart: Candidate Capabilities vs. Market Benchmark.
   - Verified Strengths & Critical Gaps summary.
2. **Interactive Assessment Room**:
   - Distraction-free scenario environment.
   - Real-world production failure scenarios (zero multiple-choice questions).
   - Monospace answer studio with quick code macros (`Idempotency Key`, `SKIP LOCKED Query`, `Mutex Lock`, `Batch RAF Sync`).
   - Adaptive difficulty state transitions based on reasoning depth.
3. **Job Insights & Gap Visualizer**:
   - Ranked jobs by compatibility percentage.
   - Status badge system: 🟢 Ready, 🟡 2 Weeks of Upskilling, 🔴 Fundamental Gaps.
   - Expandable mathematical skill ratio breakdown table.
   - Direct link to upskill for any specific job role.
4. **Learning Coach (The Autonomous Upskiller)**:
   - 3-Stage Micro-Curriculums:
     - **Stage 1: Concept**: Core mental models, failure modes, and official documentation links.
     - **Stage 2: Hands-on Task**: Concrete production scenarios with requirements and copyable starter code.
     - **Stage 3: Re-test Challenge**: In-browser practice space for submitting solutions to scenario verification questions.
   - **Dynamic Skill Updates**: Successfully passing a re-test awards a **+1.5 to +2.5 point boost**, updates `skill_profiles`, triggers celebration confetti, and recalculates all Job Match percentages in real time!

5. **Nexus AI Staff Mentor (Conversational Career & Architecture Coach)**:
   - Dedicated conversational engineering mentor grounded in the candidate's verified skill matrix.
   - Provides concrete architectural breakdowns, system design interview strategies, and actionable advice to bridge critical gaps.
   - Accessible via the top navbar and a persistent floating quick-launcher.

6. **Targeted Scenario Skill Tester (On-Demand Skill Verification)**:
   - On-demand testing of single competencies (`Caching & State`, `Database Optimization`, `System Architecture`, `Modern Frontend`, `DevOps/CI/CD`, `LLM Orchestration`).
   - Generates production failure scenarios and performs rubric-grounded grading (0–10 score, verified level, positive takeaways, missed considerations) that dynamically updates the candidate's profile matrix.

7. **Real-Time Reasoning Analyser (Live Telemetry & Checklist)**:
   - Real-time cognitive engine inspecting solutions as you type.
   - Measures Technical Depth (0–100%) and 4 core architectural dimensions:
     - ⚡ Concurrency & Race Condition Defense
     - 🛡️ Edge-Case Failure & Fallback Handling
     - 🔒 Data Integrity & Idempotency Guarantees
     - 🚀 Latency & Throughput Trade-offs
   - Features live checklist checkmarks, concept detection badges, and proactive recommendation hints.
   - Available as a standalone inspection workbench and integrated directly into the diagnostic answer studio.

---

## 🛠️ Getting Started

### Prerequisites
- Node.js `v18+` or `v24+`
- npm `v9+` or `v11+`

### Quick Start

1. **Clone or navigate to the directory**:
   ```bash
   cd "skills and job analysis agentic ai"
   ```

2. **Install dependencies**:
   ```bash
   cd backend && npm install
   cd ../frontend && npm install
   cd ..
   ```

3. **Configure Gemini API Key (Optional)**:
   You can provide your key in `backend/.env` or directly through the UI via the **Key** button in the navbar:
   ```env
   GEMINI_API_KEY=your_key_here
   GEMINI_FLASH_MODEL=gemini-1.5-flash
   GEMINI_PRO_MODEL=gemini-1.5-pro
   ```
   *Note: If no key is set, the platform operates via the built-in Agentic Cognitive Simulation Engine with realistic domain reasoning.*

4. **Run Backend and Frontend**:
   ```bash
   # Terminal 1 (Backend)
   cd backend
   node src/server.js

   # Terminal 2 (Frontend)
   cd frontend
   npm run dev
   ```

5. **Open Browser**:
   Navigate to [http://localhost:3000](http://localhost:3000)

---

## 📡 API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/health` | Backend health check |
| `GET` | `/api/system/status` | Engine mode, models, and DB statistics |
| `POST` | `/api/system/key` | Dynamically set & verify Gemini API Key |
| `POST` | `/api/mentor/chat` | Conversational AI Mentor coaching & advice |
| `GET` | `/api/tester/challenge` | Generate targeted challenge for any specific skill |
| `POST` | `/api/tester/submit` | Grade skill challenge and dynamically update score |
| `POST` | `/api/analyser/live` | Real-time cognitive architecture & reasoning inspection |
| `POST` | `/api/assessment/start` | Initialize assessment session & Turn 1 |
| `POST` | `/api/assessment/turn` | Diagnostic loop: evaluate answer, adapt difficulty, generate Turn N+1 |
| `POST` | `/api/assessment/evaluate` | Evaluator Agent: holistic rubric grading across full transcript |
| `POST` | `/api/assessment/seed-demo` | One-click seed of a full completed 5-turn assessment |
| `GET` | `/api/jobs/benchmarks` | List curated industry job benchmark profiles |
| `GET` | `/api/jobs/matches/:id` | Compute mathematical fit scores and AI verdicts |
| `GET` | `/api/roadmap/:id` | Retrieve 3-stage upskilling roadmap |
| `POST` | `/api/roadmap/generate` | Generate targeted micro-curriculum from critical gaps |
| `POST` | `/api/roadmap/retest` | Submit re-test solution, award score boost, recalculate matches |
| `GET` | `/api/files/tree` | File catalog tree for in-app code viewing & sharing |
| `GET` | `/api/files/content` | Inspect source code, line counts, byte sizes & syntax |
| `GET` | `/api/files/export-profile/:id` | Download verified candidate assessment report as Markdown (.md) |

---

## 📁 In-App Code Viewer & Sharable Dossier

The platform includes a dedicated **Project Files & Source Code Explorer** (`📁 Code & Share` tab) that allows anyone to:
1. **Browse All Files**: Instant catalog of all 10 backend agents, 10 API route modules, database schemas, and 14 frontend components.
2. **Inspect & Copy**: View syntax-styled code with line numbers, file metrics, and one-click clipboard copying.
3. **Download Individual Files**: Download any `.js`, `.jsx`, or `.md` source file directly.
4. **Export Shareable Reports**: Export a recruiter-ready Markdown assessment dossier (`Nexus_Skill_Report_<user_id>.md`) containing rubric scores, radar metrics, verified strengths, and completed micro-curriculums.

