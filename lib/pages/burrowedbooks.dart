import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_flutter_app/constants/constants.dart';

class BorrowedBooksPage extends StatelessWidget {
  final String studentId = '23926';

  const BorrowedBooksPage({super.key}); // Replace with the actual student ID

  bool isDueDateClose(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference >= 0 && difference <= 2;
  }

  TextStyle getDueDateTextStyle(DateTime dueDate) {
    if (dueDate.isBefore(DateTime.now()) || isDueDateClose(dueDate)) {
      return const TextStyle(color: Colors.red);
    }
    return const TextStyle(); // Default text style
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Borrowed Books',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: const Text(
              'Below displays the list of books you have borrowed from the NSBM Library. Please return the books within the due date to avoid penalties',
              textAlign: TextAlign.justify,
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('library_books')
                .where('student_id', isEqualTo: studentId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<QueryDocumentSnapshot> books = snapshot.data!.docs;

              if (books.isEmpty) {
                return const Center(
                  child: Text('No books borrowed.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
                  final book = books[index];

                  final borrowedDateTime =
                      (book['borrowed_date'] as Timestamp).toDate();
                  final dueDateTime = (book['due_date'] as Timestamp).toDate();

                  final borrowedDate =
                      DateFormat('yyyy-MM-dd').format(borrowedDateTime);
                  final dueDate = DateFormat('yyyy-MM-dd').format(dueDateTime);

                  return ListTile(
                    title: Text('${book['book_name']} - ${book['book_id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Borrowed Date: $borrowedDate'),
                        Text(
                          'Due Date: $dueDate',
                          style: getDueDateTextStyle(
                              (book['due_date'] as Timestamp).toDate()),
                        ),
                        SizedBox(
                          height: mobileDeviceHeight * 0.01,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 2,
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
