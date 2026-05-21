package br.fadir.com.api.repository;

import br.fadir.com.api.model.Local;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocalRepository extends JpaRepository<Local, Long> {
}