# flutter_final_d

1. Project Overview
This mobile application is a custom-built personal portfolio developed using the Flutter framework. The project serves as a comprehensive immersion into mobile architecture, demonstrating proficiency in UI/UX design, state management, backend database integration, and Artificial Intelligence (AI) implementation. It functions not just as a static portfolio, but as a dynamic application capable of real-time communication and data management.
2. Technical Stack
•	Frontend Framework: Flutter (Dart).
•	Backend Database: Supabase (Real-time data handling for Friends List and Chat Messages).
•	AI Integration: Google Gemini API (google_generative_ai package) for the virtual AI Assistant.
•	Navigation: BottomNavigationBar for main routing and Navigator.push for sub-pages.
•	Architecture: Modular widget-based structure for scalability and clean code.
3. Core Features & Functionalities
•	Home / Profile Screen: Features a high-fidelity Hero Image, personal branding, bio, and real-time statistics (e.g., Connection count synced with the database).
•	Edit Profile Feature: A dedicated screen utilizing TextFormField with controllers to update personal information dynamically.
•	Dynamic Friends List: An interactive module that allows for Adding, Editing, and Deleting friend records. These changes are synced in real-time with the Supabase database.
•	AI-Powered Chat: A sophisticated chat interface that distinguishes between human friends and the "AI Assistant." It utilizes the Google Gemini 1.5 Flash model to generate intelligent responses when chatting with the AI profile.
•	Navigation & User Flow: Implements smooth transitions between the Profile, Friends, and Settings tabs, with sub-navigation to Chat interfaces.
•	Theme Management: Includes a Toggle switch in Settings to change between Dark Mode (Red/Black aesthetic) and Light Mode.
4. Visual Documentation (Screenshots)
   
A. Home & Profile Overview
The landing page features a gradient background with a responsive profile layout. It displays key statistics which pull live data from the backend to show the exact number of connections.
 
B. About & Skills Information
The application utilizes custom widgets to display "My Skills" and "Games I Play" in a structured, card-based layout.
 
 
C. Real-time Friends List & Management
This module demonstrates full CRUD (Create, Read, Update, Delete) capabilities. Users can search for friends, add new ones via a dialog, and access options to Edit or Delete existing contacts.
 
D. AI Assistant Chat Integration
A key feature of this application. When the user initiates a chat with a friend named "AI" or "AI Assistant," the app integrates with Google Gemini to provide instant, generative AI responses, simulating a real conversation.
 
 
E. Edit Profile & Forms
The Edit Profile module ensures data integrity allows the user to update their Name, Job Title, Bio, and Location directly from the UI.
 
F. Settings & Theme Customization
The Settings screen provides user control over the application's appearance. It features a reactive Toggle Switch that instantly switches the entire application between Dark Mode (Red/Black gradient aesthetic) and Light Mode, demonstrating global state management across the widget tree.
 
 

5. Project Structure
The source code is organized to ensure readability and easy maintenance:
•	lib/main.dart: The entry point, containing the Theme configuration, Main Navigation logic, and the Profile Page UI.
•	lib/Friends.dart: Handles the Supabase integration for fetching, adding, editing, and deleting friends.
•	lib/ChatPage.dart: Contains the logic for the messaging interface, real-time message streams from Supabase, and the Google Gemini AI integration logic.
•	lib/Settings.dart: Manages app-wide settings such as the Dark/Light mode toggle.
•	lib/AboutMe.dart: Reusable UI components for the Skills and Games sections.
 

6. Implementation Highlights
•	AI Integration: Successfully integrated google_generative_ai to create a responsive chatbot. The logic automatically detects if the chat recipient is an AI and routes the prompt to the Gemini API.
•	Real-time Database: Utilized Supabase StreamBuilder to ensure that when a friend is added or a message is sent, the UI updates instantaneously without requiring a manual refresh.
•	Responsive UI: Designed with a flexible layout that adapts to Dark and Light themes, using a "Red & Black" gradient aesthetic for a modern look.
•	CRUD Operations: Implemented comprehensive data management, allowing the user to have full control over their Friends list data.
