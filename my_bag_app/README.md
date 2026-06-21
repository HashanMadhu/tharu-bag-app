# 🎒 Tharu Bag Center Mobile Application

A robust, production-ready B2C/B2B mobile application built using **Flutter**, integrated with a serverless backend powered by **Firebase**. The app is architected tailored for a bag manufacturing business to streamline direct product orders from customers and provide a comprehensive administrative control panel for business operations.

---

## 🚀 Key Architectural Features

- **Hybrid State Management:** Utilizing **Riverpod** for global business logic and synchronized real-time data streams, combined with optimized local **Stateful UI logic (`setState`)** for fast, performance-focused page filtering.
- **Backend-as-a-Service (BaaS):** Real-time data integration, offline persistence, and cloud operations managed via **Firebase (Firestore & Authentication)**.
- **Document Generation:** Native support for physical documentation handling using automated invoice processing services.

---

## 📱 Features & App Walkthrough

### 👤 Customer Side Flow

- **Secure Onboarding:** User registration, secure login, and session persistence managed via Firebase Authentication.
- **Product Catalog:** Browse through the available catalog of manufactured bag items.
- **Direct Order Placement:** A streamlined checkout workflow that allows customers to select a product, specify quantities, and instantly place orders without unnecessary intermediate steps.
- **Order History & Details:** Customers can view a detailed summary of their placed orders, including product type, quantities, and specific order parameters.
- **Real-time Status Tracking:** Track the active state of orders (Pending, Accepted, Completed) in real-time via live Firestore streams.
- **User Profile View:** A dedicated profile section displaying the currently authenticated user's email and account details.
- **Direct WhatsApp Integration:** Includes an "About Us" section with a direct communication feature that launches WhatsApp instantly to connect the customer with the business for inquiries.

### 👑 Admin Side Flow (Role-Based Dashboard)

- **Protected Admin Access:** Restricted access via role-based Firestore document validation to separate administrative tasks from general users.
- **Advanced Order Filtering:** Built-in multi-layered client-side filtering that enables administrative users to sort all received orders instantly by their active state (`Pending`, `Processing`, `Delivered`) and specific calendar dates using a dynamic Date Picker interface.
- **Real-time Order Alerts:** Implemented dynamic notification badges on the admin navigation drawer using `StreamBuilder` to instantly reflect incoming pending orders.
- **Order Lifecycle Management:** Admins can view all received orders, accept, process, and update their statuses dynamically, which instantly updates the customer's app interface.
- **Product Inventory Management:** Full control to add new bag items or delete existing products from the catalog, updating the customer-side product view in real-time.
- **Unified UX Evaluation:** Admins retain access to general customer features within the app to continuously audit and evaluate the overall user experience.
- **Automated Invoice Generation:** Equipped with a "Print Invoice" feature, enabling the admin to generate and print physical invoices for order packaging and delivery documentation.

---

## 🛠️ Tech Stack & Dependencies

- **Frontend Framework:** Flutter (Dart)
- **State Management:** Flutter Riverpod & Local State Management (`setState`)
- **Backend Services:**
  - Firebase Authentication (Secure Login & Persistence)
  - Cloud Firestore (Real-time NoSQL Database)
- **Local Tools & Services:** Custom PDF & Invoice Generation Services

---

## 🏁 Getting Started

### Prerequisites

Ensure you have the Flutter SDK configured on your machine.

### Installation & Setup

1. Clone the repository:
   git clone [https://github.com/your-username/tharu-bag-center.git](https://github.com/your-username/tharu-bag-center.git)
   cd tharu-bag-center

2.Install Flutter packages:
flutter pub get

3.Run the application:
flutter run
