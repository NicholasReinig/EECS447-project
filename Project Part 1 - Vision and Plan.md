# Library Management System  

## Vision Statement  

The Library Management System is being developed to enhance the efficiency, accessibility, and organization of a small library’s operations. Our goal is to create a robust, scalable, and user-friendly database solution that effectively manages loanable items, tracks diverse membership types, enforces borrowing policies, and generates insightful reports.  

By leveraging structured data management, automation, and optimized querying, this system will reduce manual workload for library staff and improve the overall experience for library members. The implementation of a well-designed relational database will ensure data integrity, seamless transactions, and efficient resource allocation.  

Our project focuses on delivering a highly functional and secure system that meets the evolving needs of a modern library, ensuring smooth inventory management, borrowing transactions, fine tracking, and user account maintenance.  

---

## Scope Statement  

The Library Management System will include the following key functionalities:  

- Item Management:  
  - Store and manage books, digital media, and magazines with attributes such as title, author, ISBN, genre, publication date, and availability status.  
  - Track inventory and update availability based on borrowing transactions.  

- Membership & Borrowing Rules:  
  - Maintain client records, including unique IDs, contact information, and membership types.  
  - Define multiple membership categories (e.g., regular, student, senior citizen) with specific borrowing limits and fee structures.  
  - Enforce borrowing constraints based on membership type, item category, and availability.  

- Transaction Management:  
  - Record all borrowing, returning, and reservation transactions with timestamps.  
  - Automatically update due dates and fine calculations based on overdue returns.  
  - Implement a reservation system for books currently on loan.  

- Notifications & Alerts:  
  - Notify clients about upcoming due dates, overdue items, and reserved items ready for pickup.  

- Reporting & Analytics:  
  - Generate reports on borrowing trends, fine collections, overdue books, and membership activity.  
  - Provide data-driven insights for library staff to optimize inventory and services.  

- Database Integrity & Security:  
  - Implement referential integrity constraints, normalization (3NF/BCNF), and indexing for efficient performance.  
  - Use triggers and stored procedures to automate late fee calculations and status updates.  

### Out of Scope  
- The project will not include a graphical user interface (GUI), as interactions will be conducted through SQL queries and database tools.  

---
