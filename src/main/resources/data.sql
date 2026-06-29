-- 初始化数据脚本

-- 清空现有数据（按依赖关系顺序）
DELETE FROM role_menus;
DELETE FROM role_permissions;
DELETE FROM user_roles;
DELETE FROM refresh_tokens;
DELETE FROM users;
DELETE FROM roles;
DELETE FROM permissions;
DELETE FROM menus;

-- 重置自增ID
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE roles AUTO_INCREMENT = 1;

-- 插入角色数据
INSERT INTO roles (id, name, code, description) VALUES
(1, 'ROLE_ADMIN', 'SUPER_ADMIN', '超级管理员'),
(2, 'ROLE_USER', 'TEST', '测试用户'),
(3, 'ROLE_MODERATOR', 'MODERATOR', '协管员');

-- 插入权限数据
INSERT INTO permissions (id, name, code, description, resource, action, is_active) VALUES
('permission_create', 'permission-create', 'permission:create', '创建权限', 'permission', 'create', true),
('permission_read', 'permission-read', 'permission:read', '查看权限', 'permission', 'read', true),
('permission_update', 'permission-update', 'permission:update', '更新权限', 'permission', 'update', true),
('permission_delete', 'permission-delete', 'permission:delete', '删除权限', 'permission', 'delete', true);

-- 插入菜单数据
INSERT INTO menus (id, name, code, parent_id, path, icon, sort_order, is_active, type, component, caption, info, auth, hidden, disabled, external_link) VALUES
-- 顶级分组
('group_dashboard', 'sys.nav.dashboard', 'dashboard', '', '', '', 1, true, 0, NULL, NULL, NULL, NULL, false, false, NULL),
('group_pages', 'sys.nav.pages', 'pages', '', '', '', 2, true, 0, NULL, NULL, NULL, NULL, false, false, NULL),
('group_ui', 'sys.nav.ui', 'ui', '', '', '', 3, true, 0, NULL, NULL, NULL, NULL, false, false, NULL),
('group_others', 'sys.nav.others', 'others', '', '', '', 4, true, 0, NULL, NULL, NULL, NULL, false, false, NULL),

-- 仪表板组
('workbench', 'sys.nav.workbench', 'workbench', 'group_dashboard', '/workbench', 'local:ic-workbench', 1, true, 2, '/pages/dashboard/workbench', NULL, NULL, NULL, false, false, NULL),
('analysis', 'sys.nav.analysis', 'analysis', 'group_dashboard', '/analysis', 'local:ic-analysis', 2, true, 2, '/pages/dashboard/analysis', NULL, NULL, NULL, false, false, NULL),

-- 页面组 - 管理
('management', 'sys.nav.management', 'management', 'group_pages', '/management', 'local:ic-management', 1, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('management_user', 'sys.nav.user.index', 'management:user', 'management', '/management/user', '', 1, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('management_user_profile', 'sys.nav.user.profile', 'management:user:profile', 'management_user', 'management/user/profile', '', 1, true, 2, '/pages/management/user/profile', NULL, NULL, NULL, false, false, NULL),
('management_user_account', 'sys.nav.user.account', 'management:user:account', 'management_user', 'management/user/account', '', 2, true, 2, '/pages/management/user/account', NULL, NULL, NULL, false, false, NULL),
('management_system', 'sys.nav.system.index', 'management:system', 'management', 'management/system', '', 2, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('management_system_user', 'sys.nav.system.user', 'management:system:user', 'management_system', '/management/system/user', '', 1, true, 2, '/pages/management/system/user', NULL, NULL, NULL, false, false, NULL),
('management_system_role', 'sys.nav.system.role', 'management:system:role', 'management_system', '/management/system/role', '', 2, true, 2, '/pages/management/system/role', NULL, NULL, NULL, false, false, NULL),
('management_system_permission', 'sys.nav.system.permission', 'management:system:permission', 'management_system', '/management/system/permission', '', 3, true, 2, '/pages/management/system/permission', NULL, NULL, NULL, false, false, NULL),

-- 页面组 - 菜单层级
('menulevel', 'sys.nav.menulevel.index', 'menulevel', 'group_pages', '/menu_level', 'local:ic-menulevel', 2, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('menulevel_1a', 'sys.nav.menulevel.1a', 'menulevel:1a', 'menulevel', '/menu_level/1a', '', 1, true, 2, '/pages/menu-level/menu-level-1a', NULL, NULL, NULL, false, false, NULL),
('menulevel_1b', 'sys.nav.menulevel.1b.index', 'menulevel:1b', 'menulevel', '/menu_level/1b', '', 2, true, 1, '/pages/menu-level/menu-level-1b', NULL, NULL, NULL, false, false, NULL),
('menulevel_1b_2a', 'sys.nav.menulevel.1b.2a', 'menulevel:1b:2a', 'menulevel_1b', '/menu_level/1b/2a', '', 1, true, 2, '/pages/menu-level/menu-level-1b/menu-level-2a', NULL, NULL, NULL, false, false, NULL),
('menulevel_1b_2b', 'sys.nav.menulevel.1b.2b.index', 'menulevel:1b:2b', 'menulevel_1b', '/menu_level/1b/2b', '', 2, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('menulevel_1b_2b_3a', 'sys.nav.menulevel.1b.2b.3a', 'menulevel:1b:2b:3a', 'menulevel_1b_2b', '/menu_level/1b/2b/3a', '', 1, true, 2, '/pages/menu-level/menu-level-1b/menu-level-2b/menu-level-3a', NULL, NULL, NULL, false, false, NULL),
('menulevel_1b_2b_3b', 'sys.nav.menulevel.1b.2b.3b', 'menulevel:1b:2b:3b', 'menulevel_1b_2b', '/menu_level/1b/2b/3b', '', 2, true, 2, '/pages/menu-level/menu-level-1b/menu-level-2b/menu-level-3b', NULL, NULL, NULL, false, false, NULL),

-- 页面组 - 错误页面
('error', 'sys.nav.error.index', 'error', 'group_pages', '/error', 'bxs:error-alt', 3, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('error_403', 'sys.nav.error.403', 'error:403', 'error', '/error/403', '', 1, true, 2, '/pages/sys/error/Page403', NULL, NULL, NULL, false, false, NULL),
('error_404', 'sys.nav.error.404', 'error:404', 'error', '/error/404', '', 2, true, 2, '/pages/sys/error/Page404', NULL, NULL, NULL, false, false, NULL),
('error_500', 'sys.nav.error.500', 'error:500', 'error', '/error/500', '', 3, true, 2, '/pages/sys/error/Page500', NULL, NULL, NULL, false, false, NULL),

-- UI组 - 组件
('components', 'sys.nav.components', 'components', 'group_ui', '/components', 'solar:widget-5-bold-duotone', 1, true, 1, NULL, 'sys.nav.custom_ui_components', NULL, NULL, false, false, NULL),
('components_icon', 'sys.nav.icon', 'components:icon', 'components', '/components/icon', '', 1, true, 2, '/pages/components/icon', NULL, NULL, NULL, false, false, NULL),
('components_animate', 'sys.nav.animate', 'components:animate', 'components', '/components/animate', '', 2, true, 2, '/pages/components/animate', NULL, NULL, NULL, false, false, NULL),
('components_scroll', 'sys.nav.scroll', 'components:scroll', 'components', '/components/scroll', '', 3, true, 2, '/pages/components/scroll', NULL, NULL, NULL, false, false, NULL),
('components_i18n', 'sys.nav.i18n', 'components:i18n', 'components', '/components/multi-language', '', 4, true, 2, '/pages/components/multi-language', NULL, NULL, NULL, false, false, NULL),
('components_upload', 'sys.nav.upload', 'components:upload', 'components', '/components/upload', '', 5, true, 2, '/pages/components/upload', NULL, NULL, NULL, false, false, NULL),
('components_chart', 'sys.nav.chart', 'components:chart', 'components', '/components/chart', '', 6, true, 2, '/pages/components/chart', NULL, NULL, NULL, false, false, NULL),
('components_toast', 'sys.nav.toast', 'components:toast', 'components', '/components/toast', '', 7, true, 2, '/pages/components/toast', NULL, NULL, NULL, false, false, NULL),

-- UI组 - 功能
('functions', 'sys.nav.functions', 'functions', 'group_ui', '/functions', 'solar:plain-2-bold-duotone', 2, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('functions_clipboard', 'sys.nav.clipboard', 'functions:clipboard', 'functions', '/functions/clipboard', '', 1, true, 2, '/pages/functions/clipboard', NULL, NULL, NULL, false, false, NULL),
('functions_tokenExpired', 'sys.nav.token_expired', 'functions:token_expired', 'functions', '/functions/token_expired', '', 2, true, 2, '/pages/functions/token-expired', NULL, NULL, NULL, false, false, NULL),

-- 其他组
('permission', 'sys.nav.permission', 'permission', 'group_others', '/permission', 'mingcute:safe-lock-fill', 1, true, 2, '/pages/sys/others/permission', NULL, NULL, NULL, false, false, NULL),
('permission_page_test', 'sys.nav.permission.page_test', 'permission:page_test', 'group_others', '/permission/page-test', 'mingcute:safe-lock-fill', 2, true, 2, '/pages/sys/others/permission/page-test', NULL, NULL, 'permission:read', true, false, NULL),
('calendar', 'sys.nav.calendar', 'calendar', 'group_others', '/calendar', 'solar:calendar-bold-duotone', 3, true, 2, '/pages/sys/others/calendar', NULL, '12', NULL, false, false, NULL),
('kanban', 'sys.nav.kanban', 'kanban', 'group_others', '/kanban', 'solar:clipboard-bold-duotone', 4, true, 2, '/pages/sys/others/kanban', NULL, NULL, NULL, false, false, NULL),
('disabled', 'sys.nav.disabled', 'disabled', 'group_others', '/disabled', 'local:ic-disabled', 5, true, 2, '/pages/sys/others/disabled', NULL, NULL, NULL, false, true, NULL),
('label', 'sys.nav.label', 'label', 'group_others', '#label', 'local:ic-label', 6, true, 2, NULL, NULL, 'New', NULL, false, false, NULL),
('link', 'sys.nav.link', 'link', 'group_others', '/link', 'local:ic-external', 7, true, 1, NULL, NULL, NULL, NULL, false, false, NULL),
('link_external', 'sys.nav.external_link', 'link:external_link', 'link', '/link/external_link', '', 1, true, 2, '/pages/sys/others/link/external-link', NULL, NULL, NULL, false, false, 'https://ant.design/index-cn'),
('link_iframe', 'sys.nav.iframe', 'link:iframe', 'link', '/link/iframe', '', 2, true, 2, '/pages/sys/others/link/iframe', NULL, NULL, NULL, false, false, 'https://ant.design/index-cn'),
('blank', 'sys.nav.blank', 'blank', 'group_others', '/blank', 'local:ic-blank', 8, true, 2, '/pages/sys/others/blank', NULL, NULL, NULL, false, false, NULL);

-- 插入用户数据
INSERT INTO users (id, username, email, password, avatar, nickname, phone, is_active) VALUES
(1, 'admin', 'admin@slash.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://avatars.githubusercontent.com/u/15075420', '系统管理员', '13800138000', true),
(2, 'test', 'test@slash.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://avatars.githubusercontent.com/u/15075421', '测试用户', '13800138001', true),
(3, 'guest', 'guest@slash.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://avatars.githubusercontent.com/u/15075422', '访客用户', '13800138002', true);

-- 插入用户角色关联数据
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), -- admin用户 -> 超级管理员角色
(2, 2), -- test用户 -> 测试用户角色
(3, 2), -- guest用户 -> 测试用户角色
(3, 3); -- guest用户 -> 协管员角色

-- 插入角色权限关联数据
INSERT INTO role_permissions (role_id, permission_id) VALUES
-- 超级管理员拥有所有权限
(1, 'permission_create'),
(1, 'permission_read'),
(1, 'permission_update'),
(1, 'permission_delete'),
-- 测试用户只有读取和更新权限
(2, 'permission_read'),
(2, 'permission_update'),
-- 协管员拥有读取和更新权限
(3, 'permission_read'),
(3, 'permission_update');

-- 插入角色菜单关联数据（超级管理员拥有所有菜单）
INSERT INTO role_menus (role_id, menu_id) VALUES
-- 超级管理员角色拥有所有菜单
(1, 'group_dashboard'),
(1, 'workbench'),
(1, 'analysis'),
(1, 'group_pages'),
(1, 'management'),
(1, 'management_user'),
(1, 'management_user_profile'),
(1, 'management_user_account'),
(1, 'management_system'),
(1, 'management_system_user'),
(1, 'management_system_role'),
(1, 'management_system_permission'),
(1, 'menulevel'),
(1, 'menulevel_1a'),
(1, 'menulevel_1b'),
(1, 'menulevel_1b_2a'),
(1, 'menulevel_1b_2b'),
(1, 'menulevel_1b_2b_3a'),
(1, 'menulevel_1b_2b_3b'),
(1, 'error'),
(1, 'error_403'),
(1, 'error_404'),
(1, 'error_500'),
(1, 'group_ui'),
(1, 'components'),
(1, 'components_icon'),
(1, 'components_animate'),
(1, 'components_scroll'),
(1, 'components_i18n'),
(1, 'components_upload'),
(1, 'components_chart'),
(1, 'components_toast'),
(1, 'functions'),
(1, 'functions_clipboard'),
(1, 'functions_tokenExpired'),
(1, 'group_others'),
(1, 'permission'),
(1, 'permission_page_test'),
(1, 'calendar'),
(1, 'kanban'),
(1, 'disabled'),
(1, 'label'),
(1, 'link'),
(1, 'link_external'),
(1, 'link_iframe'),
(1, 'blank'),

-- 测试用户角色只有部分菜单
(2, 'group_dashboard'),
(2, 'workbench'),
(2, 'group_pages'),
(2, 'management'),
(2, 'management_user'),
(2, 'management_user_profile'),
(2, 'error'),
(2, 'error_404'),
(2, 'group_ui'),
(2, 'components'),
(2, 'components_icon'),
(2, 'group_others'),
(2, 'permission'),

-- 协管员角色菜单
(3, 'group_dashboard'),
(3, 'workbench'),
(3, 'analysis'),
(3, 'group_pages'),
(3, 'management'),
(3, 'management_user'),
(3, 'management_user_profile');
