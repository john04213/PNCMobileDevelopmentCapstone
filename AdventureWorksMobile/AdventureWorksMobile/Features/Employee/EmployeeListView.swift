//
//  EmployeeListView.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import SwiftUI

struct EmployeeListView: View {
    @State private var viewModel: ViewModel

    init(repository: any EmployeeRepositoryProtocol) {
        viewModel = ViewModel(repository: repository)
    }

    var body: some View {
        VStack {

            LoadingBannerView(
                state: viewModel.state,
                isLoading: viewModel.isLoading,
                refreshErrorMessage: viewModel.refreshErrorMessage,
                itemName: "employees"
            )

            switch viewModel.state {
            case .loading, .idle:
                LoadingView(message: "Loading employees...")
            case .empty:
                EmptyStateView(message: "No employees found")
            case .failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadEmployees()
                    }
                })
            case .loaded:
                HStack {
                    Text("Filter")
                    TextField("Name, job title, or department", text: $viewModel.filter)
                }
                .padding()
                List(viewModel.matchingEmployees) { employee in
                    EmployeeListItem(employee: employee)
                }
                .refreshable {
                    await viewModel.loadEmployees()
                }
                .overlay {
                    if viewModel.matchingEmployees.isEmpty {
                        EmptyStateView(message: "No employees match \"\(viewModel.filter)\". Clear the filter to see all employees.")
                    }
                }
            }
        }
        .navigationTitle("Employees")
        .navigationDestination(for: EmployeeElement.self) { employee in
            EmployeeProfileView(employee: employee, repository: viewModel.repository)
        }
        .task {
            await viewModel.loadEmployees()
        }
    }
}

extension EmployeeListView {

    @Observable
    class ViewModel {

        let repository: any EmployeeRepositoryProtocol

        init(repository: any EmployeeRepositoryProtocol) {
            self.repository = repository
        }

        var state = LoadState.idle
        var refreshErrorMessage = ""
        private(set) var isLoading = false

        var employees: [EmployeeElement] = []
        var filter = ""

        // The employees whose name, job title, or department contains the filter text.
        var matchingEmployees: [EmployeeElement] {
            employees.filter { employee in
                filter == "" ||
                employee.fullName.lowercased()
                    .contains(filter.lowercased()) ||
                employee.jobTitle.lowercased()
                    .contains(filter.lowercased()) ||
                employee.department.lowercased()
                    .contains(filter.lowercased())
            }
        }

        func loadEmployees() async {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            refreshErrorMessage = ""
            if employees.isEmpty { state = LoadState.loading }
            do {
                // The API sends the employees in no particular order, so sort them by last name.
                employees = try await repository.employees().sorted { first, second in
                    if first.lastName == second.lastName {
                        return first.firstName < second.firstName
                    }
                    return first.lastName < second.lastName
                }
                if employees.isEmpty {
                    state = LoadState.empty
                } else {
                    state = LoadState.loaded
                }
            } catch {
                let message = UserFacingMessage.from(error)
                if employees.isEmpty {
                    state = LoadState.failed(message: message)
                } else {
                    refreshErrorMessage = message
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmployeeListView(repository: MockEmployeeRepository())
    }
}
