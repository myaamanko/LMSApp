import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/teacher_model.dart';
import '../providers/teacher_provider.dart';


class FilterChipList extends StatelessWidget {
  const FilterChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherProvider>(context);
    final filter = provider.filter;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilterChip(
          label: const Text("All"),
          selected: filter == TeacherType.All,
          onSelected: (_) => provider.setFilter(TeacherType.All),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text("Teaching"),
          selected: filter == TeacherType.Teaching,
          onSelected: (_) => provider.setFilter(TeacherType.Teaching),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text("Non-Teaching"),
          selected: filter == TeacherType.NonTeaching,
          onSelected: (_) => provider.setFilter(TeacherType.NonTeaching),
        ),
      ],
    );
  }
}
