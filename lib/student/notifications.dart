import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/widgets/color.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(colors),
    );
  }

  Widget _buildBody(AppColors colors) {
    // TODO: Replace with actual notification data from backend
    const isLoading = false;
    const hasError = false;
    const hasNotifications = false;

    if (isLoading) {
      return const _LoadingState();
    }

    if (hasError) {
      return _ErrorState(colors: colors);
    }

    if (!hasNotifications) {
      return _EmptyState(colors: colors);
    }

    return _NotificationList(colors: colors);
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;

  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            color: colors.hintText,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: colors.hintText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final AppColors colors;

  const _ErrorState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: colors.hintText,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load notifications',
            style: TextStyle(
              color: colors.hintText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final AppColors colors;

  const _NotificationList({required this.colors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 0, // TODO: Replace with actual notification count
      separatorBuilder: (context, index) => Divider(
        color: colors.box,
        height: 1,
      ),
      itemBuilder: (context, index) {
        // TODO: Replace with NotificationItem widget
        return const SizedBox();
      },
    );
  }
}

// TODO: Create NotificationItem widget when notification data structure is defined
// class NotificationItem extends StatelessWidget {
//   final Notification notification;
//   
//   const NotificationItem({required this.notification});
//   
//   @override
//   Widget build(BuildContext context) {
//     final colors = appColors(context);
//     
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       leading: Icon(
//         _getNotificationIcon(notification.type),
//         color: colors.green,
//       ),
//       title: Text(
//         notification.title,
//         style: TextStyle(
//           color: colors.white,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       subtitle: notification.message != null
//           ? Text(
//               notification.message!,
//               style: TextStyle(
//                 color: colors.hintText,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             )
//           : null,
//       trailing: Text(
//         _formatTime(notification.timestamp),
//         style: TextStyle(
//           color: colors.hintText,
//           fontSize: 12,
//         ),
//       ),
//       onTap: () {
//         // TODO: Handle notification tap
//       },
//     );
//   }
//   
//   IconData _getNotificationIcon(NotificationType type) {
//     switch (type) {
//       case NotificationType.exitApproved:
//         return Icons.exit_to_app;
//       case NotificationType.entryGranted:
//         return Icons.login;
//       case NotificationType.leaveApproved:
//         return Icons.nightlight_round;
//       case NotificationType.securityAlert:
//         return Icons.security;
//       case NotificationType.system:
//         return Icons.info;
//       default:
//         return Icons.notifications;
//     }
//   }
//   
//   String _formatTime(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
//     
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     }
//     return 'Just now';
//   }
// }