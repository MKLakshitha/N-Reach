import 'package:flutter/material.dart';

class BookDonationPage extends StatefulWidget {
  const BookDonationPage({super.key});

  @override
  _BookDonationPageState createState() => _BookDonationPageState();
}

class _BookDonationPageState extends State<BookDonationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _editionController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Submit form logic here

      // Clear input fields
      _bookNameController.clear();
      _editionController.clear();
      _conditionController.clear();
      _genreController.clear();
      _authorController.clear();

      // Show submission confirmation message
      // Show green SnackBar notification
      const snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Thank you for the submitting, please handover the book to the librarian and collect a special token',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Donate a Book', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter Book Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bookNameController,
                decoration: const InputDecoration(labelText: 'Book Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _editionController,
                decoration: const InputDecoration(labelText: 'Edition'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(labelText: 'Condition'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
