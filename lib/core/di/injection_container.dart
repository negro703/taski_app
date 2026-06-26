import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../../features/tasks/data/models/project_model.dart';
import '../../features/tasks/data/models/task_model.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repository_interfaces/auth_repository.dart';
import '../../features/auth/domain/usecases/register_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/watch_auth_state.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/quotes/data/datasources/quotes_remote_data_source.dart';
import '../../features/quotes/data/repositories/quotes_repository_impl.dart';
import '../../features/quotes/domain/repositories/quotes_repository.dart';
import '../../features/quotes/domain/usecases/get_daily_quote.dart';
import '../../features/quotes/presentation/cubit/quotes_cubit.dart';
import '../../features/tasks/data/datasources/tasks_local_data_source.dart';
import '../../features/tasks/data/datasources/tasks_remote_data_source.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/create_project.dart';
import '../../features/tasks/domain/usecases/create_task.dart';
import '../../features/tasks/domain/usecases/delete_project.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/domain/usecases/get_projects.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/update_task_status.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../network/api_interceptors.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  sl
    ..registerLazySingleton<Logger>(Logger.new)
    ..registerLazySingleton<ApiInterceptors>(
      () => ApiInterceptors(sl<Logger>()),
    )
    ..registerLazySingleton<Dio>(() {
      final dio = DioClient.createBaseDio();
      dio.interceptors.add(sl<ApiInterceptors>());
      return dio;
    })
    ..registerLazySingleton<DioClient>(() => DioClient(instance: sl<Dio>()))
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<GoogleSignIn>(() => GoogleSignIn())
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSource(
        firebaseAuth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
        googleSignIn: sl<GoogleSignIn>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton<WatchAuthState>(
      () => WatchAuthState(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignInWithEmail>(
      () => SignInWithEmail(sl<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterWithEmail>(
      () => RegisterWithEmail(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignInWithGoogle>(
      () => SignInWithGoogle(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        watchAuthState: sl<WatchAuthState>(),
        signInWithEmail: sl<SignInWithEmail>(),
        registerWithEmail: sl<RegisterWithEmail>(),
        signInWithGoogle: sl<SignInWithGoogle>(),
        signOut: sl<SignOut>(),
      ),
    )
    // Tasks Feature
    ..registerLazySingleton<TasksLocalDataSource>(
      () => TasksLocalDataSourceImpl(),
    )
    ..registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSource(firestore: sl<FirebaseFirestore>()),
    )
    ..registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(
        remoteDataSource: sl<TasksRemoteDataSource>(),
        localDataSource: sl<TasksLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<GetProjects>(() => GetProjects(sl<TasksRepository>()))
    ..registerLazySingleton<CreateProject>(() => CreateProject(sl<TasksRepository>()))
    ..registerLazySingleton<DeleteProject>(() => DeleteProject(sl<TasksRepository>()))
    ..registerLazySingleton<GetTasks>(() => GetTasks(sl<TasksRepository>()))
    ..registerLazySingleton<CreateTask>(() => CreateTask(sl<TasksRepository>()))
    ..registerLazySingleton<DeleteTask>(() => DeleteTask(sl<TasksRepository>()))
    ..registerLazySingleton<UpdateTaskStatus>(() => UpdateTaskStatus(sl<TasksRepository>()))
    ..registerFactory<TasksBloc>(
      () => TasksBloc(
        getProjects: sl<GetProjects>(),
        createProject: sl<CreateProject>(),
        deleteProject: sl<DeleteProject>(),
        getTasks: sl<GetTasks>(),
        createTask: sl<CreateTask>(),
        deleteTask: sl<DeleteTask>(),
        updateTaskStatus: sl<UpdateTaskStatus>(),
      ),
    )
    // Quotes Feature
    ..registerLazySingleton<QuotesRemoteDataSource>(
      () => QuotesRemoteDataSource(dio: sl<Dio>()),
    )
    ..registerLazySingleton<QuotesRepository>(
      () => QuotesRepositoryImpl(remoteDataSource: sl<QuotesRemoteDataSource>()),
    )
    ..registerLazySingleton<GetDailyQuote>(
      () => GetDailyQuote(repository: sl<QuotesRepository>()),
    )
    ..registerFactory<QuotesCubit>(
      () => QuotesCubit(getDailyQuote: sl<GetDailyQuote>()),
    );
}