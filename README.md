# Smart Hotpot Manager

A Flutter application designed to help manage hotpot restaurants efficiently. This app supports managing staff, tables, orders, and menu items, providing a seamless experience for both restaurant administrators and staff.

## Weekly Update

In the past week, we have made significant progress on the project, including:

- **Account Management Refactor**: Merged `Staff` and `Restaurant` models into a unified `Account` model. Updated related services and admin screens to use the new model. Removed unused models and services.
- **Dynamic Data Fetching**: Updated category and product screens to fetch `restaurantId` dynamically, improving scalability.
- **UI/UX Improvements**: Refactored admin table screen and components like `DataCellWidgetBadge` for better clarity and maintainability.
- **Authentication & Role Handling**: Improved login flow to handle roles and permissions, ensuring that users only access authorized screens.
- **Firestore Integration**: Optimized Firestore queries and data saving for better performance.

These updates make the app more maintainable, scalable, and ready for further feature development.

## Dev Team

- Pham Thanh Phuc - 2274802010690  
- Nguyen Thai Trong Nhan - 2274802010597
