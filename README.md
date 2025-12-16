# 🚀 VROOOM - Vehicle Rental Management System

## Introduction

VROOOM is a comprehensive cross-platform mobile application, developed as a university group
project, designed to facilitate the full vehicle rental process. It provides distinct
functionalities for both **Administrators** (fleet management, booking confirmation) and **Users** (
vehicle browsing, booking, and payment processing). The application is built upon modern software
development standards, emphasizing **scalability** and **team collaboration**.

---

## 🛠️ Technology Stack & Methodology

| Category                  | Technologies/Methodologies                                           |
|:--------------------------|:---------------------------------------------------------------------|
| **Front-End (Mobile)**    | **Flutter** (Dart), UI/UX Design                                     |
| **Architecture**          | **Clean Architecture** (Modular Development, Separation of Concerns) |
| **Back-End API**          | **Spring Boot** (Java)                                               |
| **Databases**             | **MySQL**                                                            |
| **Version Control**       | **Git / GitHub**                                                     |
| **Methodology**           | **Agile / Scrum** (Task management facilitated via **Trello**)       |
| **External Integrations** | **Stripe** (Payment Gateway), **Google Maps** (Navigation/Location)  |

---

## 🌟 Key Features

### User Functionality (Mobile)

- **Vehicle Reservation:** Users can browse and filter the vehicle fleet, and make a reservation by
  specifying dates and rental details.
- **External Payment:** Integrated **Stripe** payment gateway, redirecting users to an external web
  page for secure transaction finalization.
- **Booking Management:** Users can view their current, past, and future reservations. Statuses are
  automatically updated via a configured **CRON job** on the server.
- **Profile Management:** User profile editing, including personal information, phone number, and
  profile picture updates.
- **Location Services:** Ability to view rental location on a map within the app, with an option to
  open the location in external **Google Maps**.
- **Reservation Control:** Options to cancel or finalize a current vehicle reservation.

### Administrator Functionality (Mobile)

- **Fleet Management:** Full CRUD (Create, Read, Update, Delete) capabilities for managing the
  vehicle fleet, including detailed vehicle information.
- **Booking Confirmation:** Confirmation of future reservations to finalize the user's booking.
- **Rental Finalization:** Process for closing a rental, including recording the final mileage and
  applying fines/penalties (which the user must pay).
- **User Communication:** Direct communication capabilities from the application (click-to-call or
  click-to-email) via integrated phone and email intents.
- **Discount Code Management:** Creation and editing of discount codes (percentage-based and
  fixed-amount).
- **Rental History:** Viewing and filtering history of all past, current, and future reservations.

### Security and Authentication

- **Registration/Login:** Standard email/password authentication, enhanced with **Google** and *
  *Facebook** social sign-in.
- **Account Verification:** New user registration requires an email verification link and code input
  within the application for activation.

---

## 🧱 Architectural Highlights

The application adheres to **Clean Architecture** principles to ensure modularity and ease of
testing:

- **Separation of Concerns:** Clear boundaries between the Presentation (UI), Domain (Business
  Logic), and Data (Repository/API) layers.
- **Testing:** Logic is decoupled from the framework.

---

## 🚀 Installation and Setup

### 1. Clone the Repositories

```bash
# Clone the frontend (mobile app)
git clone [Your VROOOM GitHub Repository Link]
cd VROOOM

# Clone the backend (API)
git clone https://github.com/albertbrozyna/VROOM.git VROOOM_Backend
# Follow backend repository instructions to run the Spring Boot API (e.g., configuring MySQL and running the application)
```

### 2. Configure Network Connection

Once the Spring Boot API is running, you must set the mobile application's connection details:

1. Obtain the local IP address of the running backend server.
2. Open the file `lib/core/configs/network_config.dart`.
3. Set the IP constant within this file to match the local IP of the running backend server.

### 3. Dependencies

```bash
flutter pub get
```

### 4. Run Application

```bash
flutter run
```

---

## 👥 Project Team

* **Jakub Bak** (Role: Lead Front-End & UI/UX Designer)
    * **Key Contributions:** Designed and implemented the entire **UI/UX**. Developed the majority
      of screens and application logic (front-end). Coordinated and adapted the back-end connection
      to ensure seamless API integration.
* **Albert Brożyna** (Role: Back-End Developer)
    * **Key Contributions:** Primarily responsible for the **Spring Boot API** (back-end logic and
      database handling). Provided support and assistance in front-end development.
* **Rafał Szkopik** (Role: Front-End Developer)
    * **Key Contributions:** Focused on implementing additional front-end features and screens.
      Supported back-end implementation.