# The Oracle App - Refactoring Plan

## 阶段一：依赖项与基础设施更新 (Phase 1: Dependencies & Infrastructure)
我们需要引入新的包来支持位置、网络请求和 Firebase。
(We need to add new packages to support location, network requests, and Firebase.)

1.  **添加新的依赖 (在 `pubspec.yaml` 中) / Add New Dependencies (in `pubspec.yaml`)**:
    *   `firebase_core`, `firebase_auth`, `cloud_firestore`: 用于后台身份验证和数据存储 (For backend authentication and data storage).
    *   `geolocator`: 用于获取 GPS 经纬度 (For getting GPS coordinates).
    *   `http`: 用于调用 OpenWeatherMap API (For calling the OpenWeatherMap API).
    *   *(注：`sensors_plus` 已安装，可用于摇晃/翻转检测) / (Note: `sensors_plus` is already installed and is sufficient for shake/flip detection).*

2.  **配置 Firebase / Configure Firebase**:
    *   在项目中初始化 Firebase (`await Firebase.initializeApp()`) / Initialize Firebase in the project.
    *   确保 iOS 和 Android 端都正确配置了 `google-services.json` 和 `GoogleService-Info.plist` / Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are correctly configured.

---

## 阶段二：数据模型重构 (Phase 2: Data Model Redesign)
现有的历史记录模型需要扩展，以容纳环境和用户情绪数据。
(The existing history model needs to be extended to accommodate environmental and user mood data.)

1.  **设计新的 `DecisionNode` (抉择节点) 模型 / Design the New `DecisionNode` Model**:
    替代或扩展现有的 `HistoryItem`。模型应包含：
    (This will replace or extend the current `HistoryItem`. The model should include:)
    *   `id` (文档 ID / Document ID)
    *   `timestamp` (时间戳 / Timestamp)
    *   `tool` (使用的工具，如 Coin, Tarot / The tool used, e.g., Coin, Tarot)
    *   `result` (决策结果 / Decision result)
    *   `question` (用户的困惑/问题 - 用户输入 / User's question/dilemma - user input)
    *   `solution` (用户选择的结果 - 用户输入 / User's final solution - user input)
    *   `mood` (用户当前心情 - 用户输入 / User's current mood - user input)
    *   `latitude` & `longitude` (位置数据 / Location data)
    *   `weatherCondition` & `temperature` (天气状况与气温 / Weather condition & temperature)

---

## 阶段三：核心服务层构建 (Phase 3: Core Services Layer)
为了保持代码整洁，我们将外部交互封装成独立的服务。
(To keep the code clean, we will encapsulate external interactions into separate services.)

1.  **`AuthService`**: 负责调用 Firebase 的匿名登录 (`signInAnonymously`) / Responsible for calling Firebase's anonymous sign-in.
2.  **`FirestoreService`**: 负责将 `DecisionNode` 对象保存到 Firestore，并提供数据流供地图视图读取 / Responsible for saving `DecisionNode` objects to Firestore and providing a stream for the map view.
3.  **`EnvironmentService`**:
    *   获取设备当前 GPS 坐标 / Get the device's current GPS coordinates.
    *   根据坐标调用 OpenWeatherMap API 获取天气数据 / Call the OpenWeatherMap API with coordinates to get weather data.

---

## 阶段四：传感器交互与决策工具改造 (Phase 4: Sensor Interactions & Tool Refactoring)
调整现有的四个工具，使其严格符合物理交互要求。
(Adjust the four existing tools to strictly adhere to physical interaction requirements.)

1.  **抛掷硬币 (Coin Flip)**：利用 `sensors_plus` 的 `gyroscopeEvents`，检测设备翻转动作 / Use `gyroscopeEvents` from `sensors_plus` to detect a device flip motion.
2.  **摇签筒 (Fortune Sticks)**：利用 `userAccelerometerEvents`，设置一个震动阈值（Shake Detection）/ Use `userAccelerometerEvents` to set a shake detection threshold.
3.  **掷骰子 (Dice Roll)**：结合屏幕触控与轻度设备摇晃触发 / Triggered by a combination of screen touch and gentle device shake.
4.  **决策保存逻辑修改 / Modify Decision Saving Logic**:
    取消自动保存。在出结果后，展示一个明显的“收录至抉择地图”按钮。
    (Disable automatic saving. After a result is shown, display a prominent "Add to Decision Map" button.)

---

## 阶段五：数据采集弹窗与流程 (Phase 5: Opt-in Saving Flow)
1.  用户点击“收录至抉择地图”后，弹出一个极简的 BottomSheet 或 Dialog / When the user clicks "Add to Decision Map", show a minimal BottomSheet or Dialog.
2.  **UI 包含 / UI Includes**: 一个输入框（“你现在的困惑是什么？”）和一组心情 Emoji 选择器 / An input field ("What's on your mind?") and a set of mood emoji selectors.
3.  **后台动作 / Background Action**: 在用户填写时，后台静默调用 `EnvironmentService` 获取位置和天气 / While the user is typing, silently call `EnvironmentService` in the background to get location and weather.
4.  用户点击“保存”后，组装 `DecisionNode` 并通过 `FirestoreService` 推送上云 / After the user clicks "Save", assemble the `DecisionNode` and push it to the cloud via `FirestoreService`.

---

## 阶段六：叙事视图：水平抉择地图 (Phase 6: Narrative UI: Horizontal Decision Map)
放弃传统的垂直列表历史记录。
(Abandon the traditional vertical list for history.)

1.  **UI 结构 / UI Structure**: 使用 `ListView.builder(scrollDirection: Axis.horizontal, ...)` 构建时间线 / Use `ListView.builder(scrollDirection: Axis.horizontal, ...)` to build the timeline.
2.  **节点卡片设计 (Node Widget) / Node Widget Design**:
    *   顶部显示天气图标和温度 / Top: Display weather icon and temperature.
    *   中部展示时间、工具和最终的结果 / Middle: Display time, tool used, and the final result.
    *   底部显示用户的心情 Emoji 和问题 / Bottom: Display the user's mood emoji and their question.
    *   可以用线条将相邻的卡片连接起来，形成一条人生的“足迹” / Cards can be connected with lines to form a "life path".
