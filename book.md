# 2025.08.10

## 디렉토리 구조
```
├── _build
├── assets
├── config
├── deps
├── lib
│   ├── hello
│   ├── hello.ex
│   ├── hello_web
│   └── hello_web.ex
├── priv
└── test
```

- _build:

Mix(Elixir 빌드 시스템)가 생성하는 디렉토리, 컴파일 산출물 저장

- assets:

프론트엔드 자산(소스코드) 저장, esbuild 자동 번들링, 이미지, 폰트 같은 정적 파일은 `priv/static`에 위치

- config:

`config/config.exs` 설정 진입점, `config/dev.exs`, ` config/test.exs`, `config/prod.exs` 환경별 설정 파일
`config/runtime.exs` 실행되며, 시크릿 값이나 동적으로 변하는 설정 처리

- deps:

Mix 의존 패키지 저장

- lib:
애플리케이션 소스코드 포함하는 디렉토리, `lib/hello`(비지니스 로직) 및 `lib/hello_web` (웹 관련 기능)로 구분
`lib/hello`는 데이터베이스와 직접 상호작용하는 비지니스 도메인을 담당하며, `lib/hello_web`는 Controller, View 포함하여
웹 인터페이스 제공 역할

- priv:
코드 외 프로덕션 환경에서 필요한 자원들 저장, 데이터베이스 스크립트, 번역 파일, 이미지 등 이곳에두며, `assets` 디렉토리에서
생성된 파일은 기본적으로 `priv/static/assets` 에 저장

- test:
애플리케이션 테스트 코드 디렉토리, lib 디렉토리 구조 그대로 따라 만들기도 함

---

## `lib/hello` 디렉토리
`lib/hello` 애플리케이션의 비즈니스 도메인 구현 부분
- **application.ex**: `Hello.Application` 모듈이 저장되어 있으며, Phoenix 애플리케이션 Elixir. 데이터베이스 리포지토리, PubSub 시스템, HTTP 엔트포인트(`HelloWeb.Endpoint`) 등 시작
- **mailer.ex**: 이메일 발송을 위한 `Hello.Mailer` 모듈 정의, `Swoosh.Mailer` 사용
- **repo.ex**: `Hello.Repo` 모듈 정의, Ecto 통한 데이터베이스 인터페이스 역할 (기본은 `PostgreSQL`)


## `lib/hello_web` 디렉토리
```
lib/hello_web
├── controllers
│   ├── page_controller.ex
│   ├── page_html.ex
│   ├── error_html.ex
│   ├── error_json.ex
│   └── page_html/home.html.heex
├── components
│   ├── core_components.ex
│   ├── layouts.ex
│   └── layouts/root.html.heex
├── endpoint.ex
├── gettext.ex
├── router.ex
└── telemetry.ex
```
- `controllers` 및 `components` 디렉토리는 기본로딩되는 "Welcome to Phoenix!" 페이지 생성 구성 요소들, Phoenix는 레이아웃, HTML, 오류페이지 등에 대한 기능을 기본 제공
- **endpoint.ex**: HTTP 요청 진입점. 브라우저가 `http://localhost:4000`으로 접근하면, 이 엔드포인트를 통해 요청이 `router.ex`로 전달되고, 각 컨트롤러에 디스패치 함
- **telemetry.ex**: Phoenix의 텔레메트리 기능을 관리하는 슈퍼바이저 모듈로 성능 모니터링을 진행
- **gettext.ex**: 국제화(i18n)를 지원

---

## `assets` 디렉토리
프런트엔드 관련 소스 (Javascript, CSS 등)를 담고 있고, Phoenix v1.6부터 `esbuild`를 사용해 자산들을 컴파일.
생성된 자산은 `priv/static/assets`에 저장, 개발 모드에서는 변경사항이 자동으로 감지되어 브라우저에 반영

Twailwind CSS 프레임워크가 기본으로 설정 제공, 필요에 따라 다른 CSS 프레임워크를 사용하거나 커스텀 빌드 도구 사용 가능


## Phoenix 요청 수명 주기 (Request Life-Cycle)
### 1. 새 페이지 추가하기

브라우저가 `http://localhost:4000/`에 접근하면, Phoenix 애플리케이션은 HTTP 요청 (예: GET /, GET /hello 등)을 받게 됩니다.
이 요청은 **라우터(router)** 에 전달되어, 요청된 메소드와 경로에 맞는 **컨트롤러(controller)**의 **액션(action)**으로 매핑됩니다.

새로운 페이지를 추가하려면, 다음처럼 라우터에 새로운 경로를 정의
```
get "/hello", HelloController, :index
```
여기서 `/hello` 요청은 `HelloWeb.HelloController`의 `index/2` 액션으로 처리

### 2. 컨트롤러 작성

컨트롤러는 Elixir 모듈이며, 라우터가 전달한 요청을 처리하는 함수(액션)를 포함, 이 액션은 비즈니스 로직을 수행하고, 데이터를 준비한 뒤, 적절한 **뷰(view)**를 호출하여 응답을 렌더링

### 3. Endpoint -> Router -> Controller -> View 흐름

요청은 엔드포인트(`HelloWeb.Endpoint`)에서 시작하고 이곳에서 여러 `plug`가 순차적으로 실행된 후 최종적으로 **라우터**로 전달하고, 라우터는 요청을 알맞는 컨트롤러로 디스패치하고,
컨트롤러는 뷰에 맡겨 렌더링을 수행

### 요약: 요청 흐름 구조
| 단계             | 역할 설명                                           |
| -------------- | ----------------------------------------------- |
| **Endpoint**   | 모든 요청이 통과하는 시작점. 글로벌한 전처리 작업 (예: 로깅, 인증 등)을 수행. |
| **Router**     | HTTP 메소드 및 경로를 기반으로 컨트롤러 액션으로 요청을 분배.           |
| **Controller** | 요청 데이터를 해석하고, 비즈니스 로직 실행 후 응답에 필요한 데이터를 준비.     |
| **View**       | HTML, JSON 등 형태로 데이터를 렌더링하여 최종 응답 생성.           |
| **Response**   | 클라이언트에게 완성된 응답을 반환.                             |


# 진행중
https://hexdocs.pm/phoenix/request_lifecycle.html#layouts

## LiveView Layout
### Phoenix 1.8+ 레이아웃 시스템

- 기존: `app.html.heex` 파일 사용
- 신규: 함수 컴포넌트 기반 레이아웃

```
LiveView 렌더링 → app 함수 실행 → root.html.heex의 @inner_content

1. LiveView render 함수 실행
   ↓
2. <.app> 컴포넌트 호출
   ↓
3. app 함수가 네비게이션 + 메인 콘텐츠 조합해서 HTML 생성
   ↓
4. 그 결과가 root.html.heex의 @inner_content에 주입
   ↓
5. 최종 완성된 HTML이 브라우저로 전송
```

1. Root Layout(`root.html.heex`)
- HTML 기본 구조 (`<html>`, `<head>`, `<body>`)
- 정적 콘텐츠 (변경되지 않음)
- `{@inner_content}` 콘텐츠 주입

2. App Layout(`layouts.ex`)
- 동적 레이아웃(네비게이션, 플래시 메시지 등)
- 함수 컴포넌트로 정의
- `render_slot(@inner_block)` 으로 콘텐츠 주입

### 모범 사례
1. 추천하는 방식
- 방법: 함수 컴포넌트 기반 레이아웃
- 장점: 재사용성, 유지보수성 확장성
- 사용률: 90% 이상의 Phoenix 프로젝트에서 사용

2. 프로젝트 구조
```
lib/my_app_web/
├── components/
│   ├── layouts.ex          # 레이아웃 함수들
│   ├── layouts/
│   │   └── root.html.heex  # HTML 기본 구조
│   └── core_components.ex  # 기본 컴포넌트들
├── live/                   # LiveView 파일들
├── controllers/            # Controller 파일들
└── router.ex              # 라우팅 설정
```

3. Tip
- 성능: 정적 콘텐츠는 root layout, 동적 콘텐츠는 app layout
- 접근성: 시맨틱 HTML 태그와 ARIA 속성 사용
