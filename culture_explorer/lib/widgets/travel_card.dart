import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class TravelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String country;
  final DateTime date;
  final String status;
  final String notes;
  final double budget;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TravelCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.country,
    required this.date,
    required this.status,
    required this.notes,
    required this.budget,
    required this.onTap,
    required this.onDelete,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return AppColors.info;
      case 'visited':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Icons.calendar_today;
      case 'visited':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              SizedBox(width: 16),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 20),
                          color: AppColors.error,
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 4),
                    
                    // Country and date
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          country,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.calendar_month, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMM yyyy').format(date),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Status and budget
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getStatusIcon(status), size: 12, color: statusColor),
                              SizedBox(width: 4),
                              Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Spacer(),
                        
                        if (budget > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_money, size: 14, color: AppColors.accent),
                              SizedBox(width: 2),
                              Text(
                                '${budget.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    
                    // Notes preview
                    if (notes.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          notes.length > 50 ? '${notes.substring(0, 50)}...' : notes,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}