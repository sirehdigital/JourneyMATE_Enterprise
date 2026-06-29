# JourneyMATE Enterprise

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-4B3730?logo=riverpod)
![Material 3](https://img.shields.io/badge/UI-Material%203-7666E3?logo=material-design)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## 1. Project Overview

JourneyMATE Enterprise is a next-generation, AI-assisted travel planning platform designed to provide seamless and personalized travel experiences for corporate clients. This repository contains the source code for the Flutter-based mobile, web, and desktop application.

## 2. Vision

Our vision is to revolutionize corporate travel by leveraging AI to create intelligent, efficient, and user-centric travel management solutions. We aim to simplify every step of the journey, from booking to expense reporting, making business travel a more productive and enjoyable experience.

## 3. Key Features

- 🤖 **AI-Powered Itinerary Planning**: Intelligent suggestions for flights, hotels, and transport.
- ✈️ **Real-time Booking**: Seamless integration with travel service providers.
- 💳 **Expense Management**: Easy expense tracking and report generation.
- 📱 **Multi-Platform Support**: A consistent experience on iOS, Android, and Web.
- 📊 **Advanced Analytics**: Insights into travel spending and patterns.

## 4. Technology Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **Architecture** | Clean Architecture |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **UI Toolkit** | Material 3 |
| **Backend** | Supabase (Ready) |

## 5. Project Architecture

We adhere to **Clean Architecture** principles to maintain a separation of concerns, enhance testability, and ensure scalability. The dependency rule is strictly enforced, with dependencies only pointing inwards.

```mermaid
graph TD
    A[Presentation Layer] --> B[Domain Layer];
    C[Data Layer] --> B;

    subgraph Presentation Layer
        A
        direction LR
        subgraph Screens/Widgets
        end
        subgraph State Management (Riverpod)
        end
    end

    subgraph Domain Layer
        B
        direction LR
        subgraph Entities
        end
        subgraph Use Cases
        end
        subgraph Repository Interfaces
        end
    end

    subgraph Data Layer
        C
        direction LR
        subgraph Repository Implementations
        end
        subgraph Data Sources (API, DB)
        end
    end

    style A fill:#89CFF0
    style B fill:#90EE90
    style C fill:#FFD580
```

## 6. Folder Structure

The project uses a `feature-first` folder structure to keep related code organized and co-located.

```
/lib
├── core/                # Shared widgets, design system, utils
└── features/
    └── [feature_name]/
        ├── data/
        ├── domain/
        └── presentation/
```

## 7. Getting Started

Follow these steps to get the project running on your local machine.

1.  **Prerequisites**: Ensure you have the Flutter SDK (version 3.x) installed.
2.  **Clone the repository**:
    ```sh
    git clone https://github.com/your-org/journeymate_enterprise.git
    cd journeymate_enterprise
    ```
3.  **Install dependencies**:
    ```sh
    flutter pub get
    ```
4.  **Run the app**:
    ```sh
    flutter run
    ```

## 8. Development Workflow

We follow a standard Git workflow:
1.  Create a feature branch from `main`.
2.  Implement the feature and adhere to all coding standards.
3.  Ensure all tests and analysis pass.
4.  Open a Pull Request for review.
5.  Once approved, the PR is merged into `main`.

## 9. Coding Standards

We enforce a strict set of coding standards to maintain code quality and consistency. This includes adherence to the Effective Dart style guide, null safety, and our internal design system. For full details, please see the JourneyMATE Enterprise Engineering Handbook.

## 10. Project Roadmap

- **Q3 2026**: Launch of Core Booking & Itinerary Features (MVP).
- **Q4 2026**: Integration of Expense Management & Analytics.
- **Q1 2027**: Expansion to include team management and policy controls.

## 11. Contributing

Contributions are welcome! Please read our contributing guidelines (to be created) before submitting a pull request.

## 12. License

This project is licensed under the MIT License - see the LICENSE file for details.

## 13. Contact

For any inquiries, please contact the AI CTO.
