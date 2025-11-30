// lib/screens/detail/detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/article_model.dart';
import '../../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final String category;
  final int id;
  final String username;

  const DetailPage({super.key, required this.category, required this.id, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  Article? _article;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final article = await _apiService.fetchArticleDetail(widget.category, widget.id.toString());
      if (mounted) {
        setState(() {
          _article = article;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openArticleUrl() async {
    if (_article == null || _article!.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL not available')),
      );
      return;
    }

    final Uri url = Uri.parse(_article!.url);
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, 
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open URL')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening URL: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: _buildBody(),
      floatingActionButton: _article != null && _article!.url.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _openArticleUrl,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Read Full Article'),
              tooltip: 'Open in browser',
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error: $_error'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _fetchDetail, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_article == null) return const Center(child: Text('Article not found'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _article!.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_article!.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _article!.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(_article!.newsSite, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text(_article!.getFormattedDate(), style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Text(_article!.summary, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}