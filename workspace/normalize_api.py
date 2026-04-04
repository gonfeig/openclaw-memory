import re


def normalize_api_info(data: dict) -> dict:
    """
    标准化 API 信息字段

    1. 如果 api_name 包含路径分隔符 /，截取最后一个 / 后的内容
       - 匹配 POST:/xxx/yyy 格式，截取 yyy
       - 匹配 /xxx/yyy 格式（无方法前缀），截取 yyy
    2. 如果 api_alias 为空，根据截取后的 api_name 生成驼峰格式赋值

    Args:
        data: 包含 api_name, api_alias 等字段的字典

    Returns:
        标准化后的字典
    """
    api_name = data.get("api_name", "") or ""
    api_alias = data.get("api_alias") or ""

    # 1. 检查 api_name 是否为 METHOD:/path/xxx 或 /path/xxx 格式，截取最后一段
    # 匹配: POST:/xxx/yyy 或 /xxx/yyy（斜杠后要有内容）
    if re.match(r"^(POST|GET|PUT|DELETE|PATCH)?:?(/.+)/([^/]+)$", api_name):
        api_name = api_name.rsplit("/", 1)[-1]

    # 2. 如果 api_alias 为空，根据 api_name 生成驼峰格式
    if not api_alias:
        parts = api_name.split("-")
        if len(parts) > 1:
            api_alias = parts[0] + "".join(p.capitalize() for p in parts[1:])
        else:
            api_alias = api_name

    data["api_name"] = api_name
    data["api_alias"] = api_alias
    return data


def extract_api_subject(api_name: str) -> str:
    """
    从 LR85.02_AccountCore、H0010049.14_ExpenseReport_D 等格式中提取核心名称

    匹配格式: 前缀.版本_名称_后缀 或 前缀.版本_名称
    例如:
        LR85.02_AccountCore         → AccountCore
        H0010049.14_ExpenseReport_D → ExpenseReport
        LB97.14_PrimaryBizManager_D → PrimaryBizManager
        H0010049.14_DataService     → DataService

    Args:
        api_name: 原始字符串

    Returns:
        提取后的核心名称
    """
    # 匹配: 前缀(含字母数字).数字.数字_名称_后缀 或 前缀(含字母数字).数字.数字_名称
    m = re.match(r"^[A-Za-z0-9]+\.\d+(?:\.\d+)?_(.+?)(?:_[A-Za-z]+)?$", api_name)
    if m:
        return m.group(1)
    return api_name


if __name__ == "__main__":
    test_cases = [
        {
            "api_name": "POST:/sys/mlife-primarybiz-motservice-api-moment-of-truth-controller-api/query-pop-up-info",
            "api_alias": "",
        },
        {
            "api_name": "/sys/mlife-primarybiz-motservice-api-moment-of-truth-controller-api/query-pop-up-info",
            "api_alias": "",
        },
        {
            "api_name": "GET:/sys/user/get-user-info",
            "api_alias": "GetUser",
        },
        {
            "api_name": "simple-name",
            "api_alias": "",
        },
    ]

    for tc in test_cases:
        result = normalize_api_info(tc.copy())
        print(f"输入: {tc['api_name']!r}, {tc['api_alias']!r}")
        print(f"输出: api_name={result['api_name']!r}, api_alias={result['api_alias']!r}")
        print("-" * 60)

    print("=== extract_api_subject 测试 ===\n")
    subject_cases = [
        "LR85.02_AccountCore",
        "H0010049.14_ExpenseReport_D",
        "LB97.14_PrimaryBizManager_D",
        "H0010049.14_DataService",
    ]
    for name in subject_cases:
        print(f"输入: {name!r} → 输出: {extract_api_subject(name)!r}")
