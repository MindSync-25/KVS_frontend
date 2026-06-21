import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/kvs_button.dart';

const _districtOptions = <String>[
  'Bagalkot',
  'Ballari',
  'Belagavi',
  'Bengaluru Rural',
  'Bengaluru Urban',
  'Bidar',
  'Chamarajanagara',
  'Chikkaballapur',
  'Chikkamagaluru',
  'Chitradurga',
  'Dakshina Kannada',
  'Davanagere',
  'Dharwad',
  'Gadag',
  'Hassan',
  'Haveri',
  'Kalaburagi',
  'Kodagu',
  'Kolar',
  'Koppal',
  'Mandya',
  'Mysuru',
  'Raichur',
  'Ramanagara',
  'Shivamogga',
  'Tumakuru',
  'Udupi',
  'Uttara Kannada',
  'Vijayapura',
  'Yadgir',
];

class JoinMovementPage extends ConsumerWidget {
  const JoinMovementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Join the Movement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.lg),
        child: _ProspectiveMemberForm(),
      ),
    );
  }
}

class _ProspectiveMemberForm extends StatefulWidget {
  const _ProspectiveMemberForm();

  @override
  State<_ProspectiveMemberForm> createState() => _ProspectiveMemberFormState();
}

class _ProspectiveMemberFormState extends State<_ProspectiveMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _talukController = TextEditingController();

  String? _selectedDistrict;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _talukController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member details captured')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Member Details',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.name,
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
            decoration: const InputDecoration(
              hintText: 'Phone number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          DropdownButtonFormField<String>(
            initialValue: _selectedDistrict,
            decoration: const InputDecoration(
              hintText: 'District',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            items: _districtOptions
                .map(
                  (district) => DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedDistrict = value),
            validator: (value) =>
                value == null ? 'Please select a district' : null,
          ),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _talukController,
            textCapitalization: TextCapitalization.words,
            validator: (value) => Validators.required(value, 'Taluk'),
            decoration: const InputDecoration(
              hintText: 'Taluk',
              prefixIcon: Icon(Icons.map_outlined),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          KvsButton(
            label: 'Submit Details',
            icon: Icons.person_add_alt_1,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
