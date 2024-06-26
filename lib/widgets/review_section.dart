import 'package:flutter/material.dart';
import 'package:tobetoapp/models/review_model.dart';
import 'package:tobetoapp/repository/catalog/review_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';

class ReviewsSection extends StatefulWidget {
  final String documentId;

  const ReviewsSection({super.key, required this.documentId});

  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final ReviewsRepository _reviewsRepository = ReviewsRepository();
  final TextEditingController _reviewController = TextEditingController();
  late Future<List<Review>> _reviewsFuture;
  User? _currentUser;
  int _userRating = 0;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _reviewsRepository.getReviewsForLesson(widget.documentId);
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _addReview(String reviewText, int rating) async {
    final newReview = Review(
      catalogId: widget.documentId,
      userId: _currentUser!.uid,
      comment: reviewText,
      rating: rating,
      date: DateTime.now(),
    );

    await _reviewsRepository.addReview(newReview);
    setState(() {
      _reviewsFuture = _reviewsRepository.getReviewsForLesson(widget.documentId);
      _userRating = 0;
    });
    _reviewController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Review>>(
          future: _reviewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Bu eğitimde henüz hiç yorum bulunmamaktadır.',
              style: TextStyle(fontSize: 16.0),
              ));
            }
            final reviews = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(review.userId).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            }
                            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return const Text('Kullanıcı bulunamadı!');
                            }
                            final userData = userSnapshot.data!;
                            final firstName = userData.get('firstName') ?? 'Bilinmeyen';
                            final lastName = userData.get('lastName') ?? 'Kullanıcı';
                            final userName = '$firstName $lastName';
                            final profilePhotoUrl = userData.get('profilePhotoUrl');

                            return Row(
                              children: [
                                profilePhotoUrl != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(profilePhotoUrl),
                                        backgroundColor: Colors.grey[200],
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: Text(
                                          '${firstName[0]}${lastName[0]}',
                                          style: const TextStyle(color: AppColors.tobetoMoru),
                                        ),
                                      ),
                                const SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.tobetoMoru,
                                      ),
                                    ),
                                    Text(
                                      '${review.date.day}/${review.date.month}/${review.date.year}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          review.comment,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Puan: ', style: TextStyle(color: AppColors.tobetoMoru)),
                            _buildRatingStars(review.rating),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
        _currentUser == null
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yorum yapmak ve puan vermek için giriş yapmanız gerekmektedir!'),
                    SizedBox(height: 10),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Puanınızı verin:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.tobetoMoru),
                    ),
                    _buildRatingStars(_userRating),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Yorumunuzu buraya girin...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_reviewController.text.isNotEmpty && _userRating > 0) {
                            _addReview(_reviewController.text, _userRating);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: AppColors.tobetoMoru,
                        ),
                        child: const Text('Gönder', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 30.0,
          ),
          onPressed: () {
            setState(() {
              _userRating = index + 1;
            });
          },
          splashColor: Colors.orangeAccent,
          highlightColor: Colors.orangeAccent,
        );
      }),
    );
  }
}
