# JourneyMATE Enterprise Engineering Handbook

This document is the single source of truth for all engineering standards, processes, and best practices within the JourneyMATE Enterprise project. Adherence is mandatory to ensure we build a high-quality, scalable, and maintainable application.

## 1. Project Overview

JourneyMATE Enterprise is a next-generation, AI-assisted travel planning platform designed to provide seamless and personalized travel experiences for corporate clients.

## 2. AI Roles and Responsibilities

- **AI CTO**: Provides high-level architectural decisions, sets engineering standards, defines the overall technical strategy, and approves any changes to this handbook.
- **Senior Flutter Engineer (Gemini Code Assist)**: Responsible for implementing features, writing high-quality code, adhering to the standards defined herein, and performing refactoring tasks.

+## 3. Technology Stack

- **Flutter Version**: `3.x`
- **UI Toolkit**: `Material 3`
- **State Management**: `Riverpod`
- **Navigation**: `GoRouter`
- **Backend Integration**: `Supabase-ready` architecture

+## 4. Clean Architecture Rules

+We follow Clean Architecture to ensure a separation of concerns. The dependency rule is paramount: dependencies must only point inwards.

+- **Presentation Layer**: Contains UI-related code (Screens, Widgets, `Riverpod` Providers). It depends only on the Domain layer.
- **Domain Layer**: Contains core business logic (Entities, Use Cases, Repository interfaces). It has no dependencies on other layers.
- **Data Layer**: Contains data sources and repository implementations (API clients, database access). It depends only on the Domain layer.

+## 5. Feature-first Folder Structure

+All code is organized by feature. A typical feature directory looks like this:

```
/lib/features/[feature_name]/
├── data/
│   ├── data_sources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## 6. Flutter Coding Standards


## 7. Flutter Performance Guidelines

- **`const` Constructors**: Use `const` for widgets and constructors wherever possible to minimize rebuilds and improve performance.
- **Lazy Loading**: Use lazy loading techniques for lists and off-screen content. `ListView.builder` is mandatory for long or infinite lists.
- **Efficient Rebuilds**: Keep widget rebuilds scoped to the smallest possible part of the widget tree. Use `ref.watch` selectively and leverage `Consumer` widgets for granular control.
- **Avoid `ListView` in `Column`**: Do not place a `ListView` or other unbounded-height scrollable inside a `Column` without wrapping it in an `Expanded` or giving it a fixed height.


## 7. Widget Standards

- **Reusability**: Prioritize creating reusable components in `/lib/core/widgets/`. Avoid single-use widgets unless they are simple and scoped to a single screen file.
- **Line Limits**: Strive to keep screen files under **150 lines** and widget files under **120 lines**.

## 8. Riverpod Guidelines

- Define providers within the feature they belong to (`presentation/providers/`).
- Use `ref.watch` for rebuilding the UI in response to state changes.
- Use `ref.read` inside callbacks (e.g., `onPressed`) to prevent unnecessary rebuilds.
- Favor `NotifierProvider` and `AsyncNotifierProvider` for managing complex state.

## 9. GoRouter Guidelines

- All routes and sub-routes are defined in a central router configuration.

## 10. Design System & Tokens

- **Design Tokens**: All visual properties must be defined as tokens.
  - **Spacing**: Use `JMSpacing` for all padding, margins, and gaps.
  - **Radius**: Use `JMRadius` for all `BorderRadius` values.
  - **Elevation**: Use `JMShadows` for all `BoxShadow` effects.
  - **Animations**: Use `JMAnimation` for standard animation durations and curves.
  - **Icon Sizes**: Use predefined constants for icon sizes to ensure consistency.

## 11. Responsive Design Rules


## 12. Git Workflow

- **Main Branch**: The `main` branch is always production-ready. Direct commits are forbidden.

## 13. AI Development Workflow

1.  **Task Assignment**: The AI CTO assigns a task with clear requirements.
2.  **Implementation**: The Senior Flutter Engineer (Gemini) implements the task, generating complete development packages (not isolated files).
3.  **Code Generation**: All generated code must adhere strictly to this handbook.
4.  **Self-Correction**: Before finalizing, the engineer must ensure `flutter analyze` passes with zero issues and all tests are passing.
5.  **Summary & PR**: A summary of all created/modified files is provided. A PR is implicitly ready for review.

## 14. Documentation Standards

- **File Headers**: Add a file header comment for new files where appropriate to describe the file's purpose.
- **Public APIs**: All public classes, methods, and functions must have clear and concise DartDoc comments.
- **Complex Logic**: Explain complex or non-obvious business logic with inline comments.

## 14. Testing Requirements


## 15. Flutter Analyzer Rules

- **No Warnings**: Treat warnings as errors.
- **No Deprecated APIs**: Do not use deprecated APIs. Refactor existing code if a deprecated API is encountered.
- **No `print()` Statements**: Use a dedicated logger instead of `print()`.
- **No `// TODO` before Merge**: All `TODO` comments must be resolved or converted into tickets before merging to `main`.

## 16. Sprint Workflow


## 17. Definition of Done Checklist

A task is "Done" only when all of the following are checked:

- [ ] All acceptance criteria for the task are met.
- [ ] Code adheres to all standards in this handbook.
- [ ] All required tests (unit, widget, integration) are written and passing.
- [ ] `flutter analyze` passes with zero issues (no errors, warnings, or lints).
- [ ] All `print()` and `TODO` statements have been removed.
- [ ] The code has been reviewed and approved by the AI CTO.
- [ ] The feature branch has been successfully merged into `main`.

## 18. AI CTO Collaboration Rules

- My role is implementation. Architecture decisions will be provided by the AI CTO.
- I will always provide a summary of created or modified files with each task completion.
- I will not modify the existing architecture, public APIs, or folder structures without explicit instruction.
- I will always ask for approval before making changes that could affect other parts of the system.
- I will await approval before creating any new documentation files.