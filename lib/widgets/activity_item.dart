import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/activity_provider.dart';
import 'package:storygram/services/auth_services.dart';
import 'package:storygram/widgets/activity_card.dart';

class ActivityItem extends ConsumerStatefulWidget {
  const ActivityItem(this.userId, {super.key});

  final String userId;

  @override
  ConsumerState<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends ConsumerState<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(activityProvider(widget.userId));

    return activityAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (snapshot) {
        if (snapshot.docs.isEmpty) {
          return Center(child: Text('No activity yet'));
        }

        return ListView.separated(
          itemCount: snapshot.docs.length,
          itemBuilder: (ctx, index) {
            final activity = snapshot.docs[index].data();

            final createdAt = activity['createdAt'] as Timestamp;
            final timeAgo = _timeDifference(createdAt.toDate());

            final currentUserId = AuthServices().currentUserId;

            final fromUserId = activity['fromUserId'];

            if (currentUserId == fromUserId) {
              return Center(child: Text('No activity yet'));
            }

            return ActivityCard(
              username: activity['fromUsername'],
              message: activity['message'],
              postId: activity['postId'],
              timeAgo: timeAgo,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(padding: EdgeInsets.all(2));
          },
        );
      },
    );
  }

  String _timeDifference(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
