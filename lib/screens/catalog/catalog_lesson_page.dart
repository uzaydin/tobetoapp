// import 'package:flutter/material.dart';

// class CatalogLessonPage extends StatefulWidget {
//   const CatalogLessonPage ({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CatalogLessonPageState createState() => _CatalogLessonPageState();
// }

// class _CatalogLessonPageState extends State<CatalogLessonPage> {
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Ders Adı'),
//             IconButton(
//               icon: const Icon(Icons.favorite_border),
//               onPressed: () {
//                 // Favorilere ekleme işlemi
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.bookmark_border),
//               onPressed: () {
//                 // Kaydetme işlemi
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Tamamlanma Durumu ve Tarih Bilgisi
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Bu dersi 30 Haziran 2024 tarihine kadar bitirebilirsin',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 5),
//                 LinearProgressIndicator(value: 0.4), // %40 tamamlandı
//                 SizedBox(height: 5),
//                 Text(
//                   '%40 Tamamlandı',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//           // Ders Videosu
//           Container(
//             color: Colors.grey,
//             height: 200,
//             width: double.infinity,
//             child: const Center(
//               child: Text(
//                 'Ders Videosu',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//           // İçerik/Hakkında/Katılımcılar Sekmeleri
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ToggleButtons(
//               isSelected: [selectedIndex == 0, selectedIndex == 1, selectedIndex == 2],
//               onPressed: (int index) {
//                 setState(() {
//                   selectedIndex = index;
//                 });
//               },
//               children: const [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text('İçerik'),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text('Hakkında'),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text('Katılımcılar'),
//                 ),
//               ],
//             ),
//           ),
//           // Seçili Sekmeye Göre İçeriğin Gösterimi
//           Expanded(
//             child: selectedIndex == 0
//                 ? ListView(
//                     children: const [
//                       ListTile(title: Text('Video 1')),
//                       ListTile(title: Text('Video 2')),
//                       ListTile(title: Text('Video 3')),
//                     ],
//                   )
//                 : selectedIndex == 1
//                     ? const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Başlangıç Tarihi: 1 Ocak 2024'),
//                             Text('Bitiş Tarihi: 30 Haziran 2024'),
//                             Text('Tahmini Süre: 6 ay'),
//                             Text('Eğitim Türü: Online'),
//                             Text('Eğitim: Flutter Geliştirme'),
//                             Text('Kategori: Yazılım'),
//                             Text('Seviye: Başlangıç'),
//                             Text('Üretici Firma: Tobeto'),
//                             Text(
//                               'Açıklama: Bu eğitim, Flutter ile mobil uygulama geliştirme konusunda temel bilgileri içermektedir.',
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView(
//                         children: const [
//                           ListTile(title: Text('Katılımcı 1')),
//                           ListTile(title: Text('Katılımcı 2')),
//                           ListTile(title: Text('Katılımcı 3')),
//                         ],
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_state.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/screens/catalog/catalog_video_list_widget.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/sample_player.dart';

class CatalogLessonPage extends StatefulWidget {
  final CatalogModel catalogId;

  const CatalogLessonPage({super.key, required this.catalogId});

  @override
  _CatalogLessonPageState createState() => _CatalogLessonPageState();
}

class _CatalogLessonPageState extends State<CatalogLessonPage> {
  String? _currentVideoUrl;
  Video? _currentVideo;
  Duration _totalSpentTime = Duration.zero;
  final Map<String, Duration> _videoSpentTimes = {};

  @override
  void initState() {
    super.initState();
    _loadVideos();
    initializeDateFormatting();
  }

  void _loadVideos() {
    final userId = context.read<AuthBloc>().currentUser?.id;
    if (userId != null) {
      context.read<CatalogVideoBloc>().add(
            LoadVideos(
              catalogId: widget.catalogId.catalogId!,
              videoIds: widget.catalogId.videoIds ?? [],
            ),
          );
    }
  }

  void _onVideoTap(Video video) {
    setState(() {
      _currentVideoUrl = video.link;
      _currentVideo = video;
      _totalSpentTime = _videoSpentTimes[video.id] ?? Duration.zero;
    });
  }

  void _onVideoComplete() {
    if (_currentVideo != null) {
      final userId = context.read<AuthBloc>().currentUser?.id;
      if (userId != null) {
        context.read<CatalogVideoBloc>().add(
              UpdateSpentTime(
                userId: userId,
                catalogId: widget.catalogId.catalogId!,
                videoId: _currentVideo!.id,
                spentTime: _totalSpentTime,
                videoIds: widget.catalogId.videoIds ?? [],
              ),
            );
      }
      context.read<CatalogVideoBloc>().add(
            VideoSelected(
              catalogId: widget.catalogId.catalogId!,
              video: _currentVideo!,
              videoIds: widget.catalogId.videoIds ?? [],
            ),
          );
    }
  }

  void _onTimeUpdate(Duration spentTime) {
    setState(() {
      _totalSpentTime = spentTime;
      if (_currentVideo != null) {
        _videoSpentTimes[_currentVideo!.id] = spentTime;
      }
    });
  }

  double _calculateProgress(List<Video> videos) {
    if (videos.isEmpty) return 0.0;
    final completedVideos = videos.where((video) => video.isCompleted!).length;
    return completedVideos / videos.length;
  }

  Duration _calculateSpentTime(List<Video> videos) {
    return videos.fold(
      Duration.zero,
      (sum, video) => sum + (video.spentTime ?? Duration.zero),
    );
  }

  void _showInfoDialog(BuildContext context, List<Video> videos) {
    final spentTime = _calculateSpentTime(videos);
    final startDate = widget.catalogId.startDate;
    final endDate = widget.catalogId.endDate;
    final videoCount = videos.length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Hakkında',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    'Başlangıç: ${startDate != null ? DateFormat('dd MMM yyyy').format(startDate) : 'Belirtilmemiş'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bitiş: ${endDate != null ? DateFormat('dd MMM yyyy').format(endDate) : 'Belirtilmemiş'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Geçirdiğin Süre: ${spentTime.inHours} saat ${spentTime.inMinutes.remainder(60)} dakika',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.video_library),
                  const SizedBox(width: 8),
                  Text(
                    'Video: $videoCount',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat', style: TextStyle(color: Colors.blue)),
            ),
          ],
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tobeto"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(child: _buildVideoList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.catalogId.title ?? 'Başlık Yok',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            BlocBuilder<CatalogFavoritesBloc, CatalogFavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoaded) {
                  final isFavorite = state.favoriteCatalogIds
                      .contains(widget.catalogId.catalogId);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () {
                      _toggleFavorite(context, isFavorite);
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                final videoBloc = context.read<CatalogVideoBloc>();
                if (videoBloc.state is VideosLoaded) {
                  final videos = (videoBloc.state as VideosLoaded).videos;
                  _showInfoDialog(context, videos);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _toggleFavorite(BuildContext context, bool isFavorite) {
    if (isFavorite) {
      context
          .read<CatalogFavoritesBloc>()
          .add(RemoveFavorite(catalogId: widget.catalogId.catalogId!));
    } else {
      context
          .read<CatalogFavoritesBloc>()
          .add(AddFavorite(catalogId: widget.catalogId.catalogId!));
    }
  }

  Widget _buildVideoList(BuildContext context) {
    return BlocBuilder<CatalogVideoBloc, CatalogVideoState>(
      builder: (context, state) {
        if (state is VideosLoaded) {
          final progress = _calculateProgress(state.videos) * 100;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(progress),
              const SizedBox(height: 16),
              if (_currentVideoUrl != null)
                SamplePlayer(
                  key: ValueKey(_currentVideoUrl),
                  videoUrl: _currentVideoUrl!,
                  onVideoComplete: _onVideoComplete,
                  onTimeUpdate: _onTimeUpdate,
                ),
              const SizedBox(height: 16),
              Expanded(child: VideoListWidget(onVideoTap: _onVideoTap)),
            ],
          );
        } else if (state is VideoOperationFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 100 ? Colors.green : Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('%${progress.toStringAsFixed(0)}'),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        SamplePlayer(
          key: ValueKey(_currentVideoUrl),
          videoUrl: _currentVideoUrl!,
          onVideoComplete: _onVideoComplete,
          onTimeUpdate: _onTimeUpdate,
        ),
      ],
    );
  }
}


//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       DocumentSnapshot courseDoc = await FirebaseFirestore.instance
//           .collection('catalog')
//           .doc(widget.catalogId)
//           .get();

//       if (courseDoc.exists) {
//         setState(() {
//           title = courseDoc['title'];
//           completionDate = (courseDoc['completionDate'] as Timestamp).toDate();
//           progress = courseDoc['progress'];
//           progressText = "${(progress * 100).toStringAsFixed(0)}% Tamamlandı";
//           videoIds = List<String>.from(courseDoc['videoIds'] ?? []);
//           participants = List<String>.from(courseDoc['participants'] ?? []);
//         });
//       } else {
//         setState(() {
//           error = 'Course not found';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Failed to fetch course data: $e';
//       });
//       print('Error fetching catalog data: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title ?? 'Ders Adı'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border),
//             onPressed: () {
//               // Favorilere ekleme işlemi
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.bookmark_border),
//             onPressed: () {
//               // Kaydetme işlemi
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//               ? Center(child: Text('Error: $error'))
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Bu dersi $completionDate tarihine kadar bitirebilirsin',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 5),
//                           LinearProgressIndicator(value: progress),
//                           const SizedBox(height: 5),
//                           Text(
//                             progressText ?? '',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       color: Colors.grey,
//                       height: 200,
//                       width: double.infinity,
//                       child: const Center(
//                         child: Text(
//                           'Ders Videosu',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ToggleButtons(
//                         isSelected: [
//                           selectedIndex == 0,
//                           selectedIndex == 1,
//                           selectedIndex == 2
//                         ],
//                         onPressed: (int index) {
//                           setState(() {
//                             selectedIndex = index;
//                           });
//                         },
//                         children: const [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Text('İçerik'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Text('Katılımcılar'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: selectedIndex == 0
//                           ? ListView.builder(
//                               itemCount: videoIds.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   title: Text(videoIds[index]),
//                                 );
//                               },
//                             )
//                           : ListView.builder(
//                                   itemCount: participants.length,
//                                   itemBuilder: (context, index) {
//                                     return ListTile(
//                                       title: Text(participants[index]),
//                                     );
//                                   },
//                                 ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }
