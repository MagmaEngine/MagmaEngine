#include <Windows.h>

// Declare the callback function for handling messages
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	// Register the window class
	const char CLASS_NAME[] = "Sample Window Class";

	WNDCLASS wc = {0};

	wc.lpfnWndProc = WindowProc;
	wc.hInstance = hInstance;
	wc.lpszClassName = CLASS_NAME;

	RegisterClass(&wc);

	// Create the window
	HWND hwnd = CreateWindowEx(
		0,						  // Optional window styles
		CLASS_NAME,				 // Window class
		"Hello, Windows!",		  // Window title
		WS_OVERLAPPEDWINDOW,		// Window style

		// Size and position
		CW_USEDEFAULT, CW_USEDEFAULT, 800, 600,

		NULL,	   // Parent window
		NULL,	   // Menu
		hInstance,  // Instance handle
		NULL		// Additional application data
	);

	if (hwnd == NULL) {
		return 0;
	}

	// Show the window
	ShowWindow(hwnd, nCmdShow);
	UpdateWindow(hwnd);

	// Run the message loop
	MSG msg = {0};
	while (GetMessage(&msg, NULL, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}

// Window procedure function
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg) {
		case WM_DESTROY:
			PostQuitMessage(0);
			return 0;

		case WM_PAINT: {
			PAINTSTRUCT ps;
			HDC hdc = BeginPaint(hwnd, &ps);

			// Draw "Hello, Windows!" in the center of the window
			RECT rect;
			GetClientRect(hwnd, &rect);
			DrawText(hdc, "Hello, Windows!", -1, &rect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

			EndPaint(hwnd, &ps);
			return 0;
		}

		default:
			return DefWindowProc(hwnd, uMsg, wParam, lParam);
	}
}

