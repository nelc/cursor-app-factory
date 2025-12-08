# 📋 Prompt Template: Copy & Fill This

**Use this exact format when prompting Cursor AI**

---

## Step 1: Describe Your App (Put This FIRST)

```
Build a [YOUR APP TYPE] where users can:
- [Feature 1]
- [Feature 2]
- [Feature 3]
- [Feature 4]

Use [design preferences].
```

---

## Step 2: Add Technical Requirements (Put This SECOND)

Copy **all of MAGIC_PROMPT.md** here (the entire technical requirements section)

---

## ✅ Complete Example (Copy This Format)

```
Build a task management app where users can:
- Create tasks with title, description, and due date
- Mark tasks as complete
- Delete tasks
- Filter by status (all/active/completed)

Use a modern design with blue accents.

---

[PASTE ENTIRE MAGIC_PROMPT.MD HERE]
```

---

## 🎯 More Examples

### Customer Feedback System

```
Build a customer feedback system where:
- Customers submit name, email, rating (1-5 stars), and comments
- Admin dashboard shows all feedback in a sortable table
- Filter by rating
- Mark feedback as "reviewed" or "pending"
- Export feedback to CSV

Use clean, professional design with company blue (#0066cc).

---

[PASTE ENTIRE MAGIC_PROMPT.MD HERE]
```

### Inventory Tracker

```
Build an inventory management system where:
- Add/edit/delete products with: name, SKU, quantity, location
- Low stock alerts when quantity < 10 (show in red)
- Search by name or SKU
- Barcode scanner support (input field accepts scanned codes)
- Export inventory to Excel

Use data-focused, minimal design.

---

[PASTE ENTIRE MAGIC_PROMPT.MD HERE]
```

### Meeting Room Booking

```
Build a meeting room booking system where:
- 4 rooms: Conference A (20 people), Conference B (12 people), Small 1 (4 people), Small 2 (4 people)
- Calendar view showing room availability by day
- Book rooms in 30-minute increments (8 AM - 6 PM)
- Users see their upcoming bookings
- Email confirmation when booking is made
- Can cancel bookings (requires confirmation)

Use modern calendar UI, color-code by room.

---

[PASTE ENTIRE MAGIC_PROMPT.MD HERE]
```

---

## 💡 Tips for Better Results

### Be Specific About Features
❌ "Add user management"  
✅ "Users can: register, login, reset password via email, update profile with photo upload"

### Describe the UX
❌ "Make it look good"  
✅ "Clean, minimal design with sidebar navigation, card-based layout, blue (#0066cc) primary color"

### Mention Technical Details If Needed
❌ "Store data"  
✅ "Store in PostgreSQL, auto-backup daily, support 10,000+ records"

### Include Edge Cases
❌ "Let users upload files"  
✅ "Let users upload files (max 10MB, support PDF/PNG/JPG, show preview, validate before upload)"

---

## 🚀 Ready to Start?

1. Copy this template
2. Fill in YOUR app description (what you want)
3. Paste entire MAGIC_PROMPT.md below it
4. Give to Cursor AI (Cmd+L)
5. Wait 1-2 minutes
6. Test: `docker-compose up -d`
7. Deploy: `make deploy`

---

## ✅ Verify These Features Were Created

After Cursor generates your app, check for:

- [ ] `Dockerfile` and `docker-compose.yaml` exist
- [ ] Login/Register pages
- [ ] First user becomes admin automatically
- [ ] **Settings page** (admin only, database-backed)
- [ ] Health check at `/health`
- [ ] App runs on port 8080

**If Settings page is missing**, tell Cursor:
```
Add an admin-only Settings page that stores configuration 
in a database Settings table using key-value pairs.
```

**You're ready!** 🎉

