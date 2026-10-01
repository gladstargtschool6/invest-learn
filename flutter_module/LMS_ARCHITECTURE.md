# Learning Management System architecture

The mobile app contains an API-backed LMS client and an empty-state-first course library. It intentionally does not bundle the course catalog: courses, modules, lessons, quizzes, assignments, progress, certificates, and categories belong in the backend and are fetched with pagination.

## Recommended records

- `categories`: id, name, slug, parent_id, active
- `courses`: id, title, descriptions, category_id, level, objectives, duration, instructor_id, thumbnail_url, access_tier, status, version, created_by
- `modules`: id, course_id, title, order
- `lessons`: id, module_id, title, summary, content_ref, order, access_tier
- `question_bank`: id, lesson_id, type, prompt, options, answer, explanation, difficulty, topic
- `quizzes`: id, course_id/module_id/lesson_id, title, question_count, pass_score
- `assignments`: id, lesson_id, instructions, rubric, submission_type
- `learning_paths`: id, title, course_ids, access_tier
- `enrollments`: user_id, course_id, started_at, completed_at
- `lesson_progress`: user_id, lesson_id, completed_at, seconds_spent
- `quiz_attempts`: user_id, quiz_id, question_ids, score, answers, created_at
- `certificates`: user_id, course_id, certificate_number, completed_at, duration

## API requirements

Use authenticated, role-protected endpoints such as:

- `GET /courses?page=1&pageSize=20&category=...`
- `GET /courses/{id}`
- `POST /admin/courses/generate` — duplicate search first; return a validated draft
- `POST /admin/courses/{id}/publish`
- `POST /admin/quizzes/generate`
- `POST /courses/{id}/progress`
- `POST /quizzes/{id}/attempts`
- `GET /me/learning-summary`

The server must validate AI output against a versioned JSON schema before persistence. Quiz answers must never be sent to untrusted learner clients before an attempt is submitted. Randomize question and option order server-side using a seeded attempt, and store the selected question IDs for review.

## Access and personalization

Every course, lesson, assignment, and certificate endpoint checks the server-side subscription entitlement and account role. Free users receive only published free records and configured limits. Recommendations use completed lessons, scores, weak topics, goals, and history; low scores create revision recommendations. Do not rely on a Flutter boolean for authorization.

## Certificates and duplicate protection

Before generating a course, normalize the requested topic and compare it against titles, objectives, categories, and embeddings/search terms. Return possible duplicates to the administrator for confirmation. Certificates are issued only after required lessons, assignments, and final assessment pass criteria are verified server-side.

The admin dashboard should expose paginated course management, draft review, quiz generation, category management, learner analytics, completion rates, quiz performance, certificate issuance, and subscription-aware access controls. This design allows unlimited content additions without an app release.
