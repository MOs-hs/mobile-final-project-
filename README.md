# Healthy Meal Planner - Setup Instructions

## Overview
This is a full-stack meal planning application with:
- **Backend:** PHP RESTful API with MySQL database
- **Frontend:** Flutter mobile application

---

## Backend Setup (PHP API)

### Prerequisites
- PHP 8.0 or higher
- MySQL 8.0 or higher
- XAMPP, WAMP, or any web server with PHP and MySQL support

### Installation Steps

1. **Place API Files**
   - Copy the `healthy_meal_planner_api` folder to your web server root directory
   - For XAMPP: `C:\xampp\htdocs\healthy_meal_planner_api`
   - For WAMP: `C:\wamp64\www\healthy_meal_planner_api`

2. **Create Database**
   - Open phpMyAdmin or MySQL command line
   - Import the database schema:
   ```bash
   mysql -u root -p < healthy_meal_planner_api/database.sql
   ```
   - Or manually execute the SQL in phpMyAdmin

3. **Configure Database Connection**
   - Edit `healthy_meal_planner_api/config/db.php`
   - Update credentials if needed:
   ```php
   $host = '127.0.0.1';
   $db   = 'healthy_meal_planner';
   $user = 'root';
   $pass = ''; // Your MySQL password
   ```

4. **Test API Endpoints**
   - Start your web server (XAMPP/WAMP)
   - Visit: `http://localhost/healthy_meal_planner_api/meals/list.php`
   - You should see JSON response with sample meals

### API Endpoints

#### Authentication
- `POST /auth/register.php` - Register new user
- `POST /auth/login.php` - User login

#### Meals
- `GET /meals/list.php` - List all meals
- `POST /meals/create.php` - Create new meal
- `POST /meals/update.php` - Update meal
- `POST /meals/delete.php` - Delete meal

#### Meal Plans
- `GET /mealplans/list_by_user.php?user_id=X` - List user's meal plans
- `POST /mealplans/create.php` - Create meal plan
- `POST /mealplans/update_totals.php` - Update plan totals
- `POST /mealplans/delete.php` - Delete meal plan

#### Meal Plan Meals
- `POST /mealplanmeals/add.php` - Add meal to plan
- `GET /mealplanmeals/list_by_plan.php?mealplan_id=X` - List meals in plan
- `POST /mealplanmeals/delete.php` - Remove meal from plan
- `GET /mealplanmeals/weekly_view.php?user_id=X&week_start=YYYY-MM-DD&week_end=YYYY-MM-DD` - Weekly view

---

## Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Android Studio or VS Code with Flutter extensions
- Android emulator or physical device

### Installation Steps

1. **Navigate to Flutter Project**
   ```bash
   cd "C:\Users\Mo\Desktop\mobile final project\healthy_meal_planner"
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API URL**
   - Edit `lib/core/constants.dart`
   - Update `apiBase` to your server URL:
   ```dart
   // For Android emulator connecting to localhost
   static const String apiBase = 'http://10.0.2.2/healthy_meal_planner_api';
   
   // For physical device (use your computer's IP)
   static const String apiBase = 'http://192.168.1.X/healthy_meal_planner_api';
   
   // For iOS simulator
   static const String apiBase = 'http://localhost/healthy_meal_planner_api';
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### Default Credentials
- Email: `mohamad@gmail.com`
- Password: `password` (default hash in database.sql)

---

## Project Structure

### Backend (PHP)
```
healthy_meal_planner_api/
├── config/
│   └── db.php                 # Database connection
├── utils/
│   ├── response.php           # JSON response helpers
│   └── auth.php               # Authentication helpers
├── auth/
│   ├── register.php           # User registration
│   └── login.php              # User login
├── meals/
│   ├── list.php               # List all meals
│   ├── create.php             # Create meal
│   ├── update.php             # Update meal
│   └── delete.php             # Delete meal
├── mealplans/
│   ├── list_by_user.php       # User's meal plans
│   ├── create.php             # Create meal plan
│   ├── update_totals.php      # Update plan totals
│   └── delete.php             # Delete meal plan
├── mealplanmeals/
│   ├── add.php                # Add meal to plan
│   ├── list_by_plan.php       # List plan meals
│   ├── delete.php             # Remove from plan
│   └── weekly_view.php        # Weekly schedule
└── database.sql               # Database schema
```

### Frontend (Flutter)
```
lib/
├── main.dart                   # App entry point
├── core/
│   ├── constants.dart         # API configuration
│   └── api_client.dart        # HTTP client
├── models/
│   ├── user.dart              # User model
│   ├── meal.dart              # Meal model
│   ├── meal_plan.dart         # Meal plan model
│   └── meal_plan_meal.dart    # Plan meal model
├── services/
│   ├── auth_service.dart      # Auth API calls
│   ├── meal_service.dart      # Meal API calls
│   ├── meal_plan_service.dart # Plan API calls
│   └── meal_plan_meal_service.dart
└── screens/
    ├── login_screen.dart      # Login UI
    ├── meals_screen.dart      # Meals list UI
    └── weekly_plan_screen.dart # Weekly plan UI
```

---

## Troubleshooting

### Backend Issues

**CORS Errors**
- Ensure `utils/response.php` is included in all endpoints
- Check browser console for specific CORS errors

**Database Connection Failed**
- Verify MySQL is running
- Check credentials in `config/db.php`
- Ensure database `healthy_meal_planner` exists

**404 Errors**
- Verify API folder is in web server root
- Check file paths and spelling
- Ensure `.php` extension in URLs

### Frontend Issues

**Connection Refused**
- Update API URL in `lib/core/constants.dart`
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For physical device, use computer's local IP address

**No Data Showing**
- Check if backend is running and accessible
- Verify database has sample data
- Check network tab in browser/debug tools

---

## Next Steps

1. **Enhance UI**
   - Add meal creation forms
   - Improve weekly plan visualization
   - Add calendar date picker

2. **Add Features**
   - Meal search and filtering
   - Recipe images
   - Shopping list generation
   - Nutritional goals tracking

3. **Security Improvements**
   - Implement JWT tokens
   - Add request validation
   - Secure password requirements
   - Rate limiting

4. **Production Deployment**
   - Use environment variables
   - Enable HTTPS
   - Optimize database queries
   - Add error logging

---

## Support

For issues or questions, check:
- PHP error logs: `xampp/apache/logs/error.log`
- Flutter logs: Run with `flutter run -v`
- MySQL logs: Check phpMyAdmin or MySQL error log
