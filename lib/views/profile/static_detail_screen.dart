import 'package:flutter/material.dart';

class StaticDetailScreen extends StatelessWidget {
  const StaticDetailScreen({
    super.key,
    required this.title,
    required this.description,
    this.sections = const <StaticDetailSection>[],
  });

  final String title;
  final String description;
  final List<StaticDetailSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...sections.map((section) => _SectionCard(section: section)),
        ],
      ),
    );
  }
}

class StaticDetailSection {
  const StaticDetailSection({
    required this.title,
    required this.items,
    this.icon,
  });

  final String title;
  final List<String> items;
  final IconData? icon;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final StaticDetailSection section;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (section.icon != null) ...[
                  Icon(
                    section.icon,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...section.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.grey[300], height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
