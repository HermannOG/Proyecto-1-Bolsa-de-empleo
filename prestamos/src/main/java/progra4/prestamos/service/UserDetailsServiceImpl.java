package progra4.prestamos.service;

import progra4.prestamos.model.Administrador;
import progra4.prestamos.model.Empresa;
import progra4.prestamos.model.Oferente;
import progra4.prestamos.repository.AdministradorRepository;
import progra4.prestamos.repository.EmpresaRepository;
import progra4.prestamos.repository.OferenteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final EmpresaRepository  empresaRepo;
    private final OferenteRepository oferenteRepo;
    private final AdministradorRepository adminRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        // 1. Buscar como empresa
        var empresa = empresaRepo.findByCorreo(username);
        if (empresa.isPresent()) {
            Empresa e = empresa.get();
            if (!e.getAprobada()) throw new UsernameNotFoundException("Empresa no aprobada");
            return new User(e.getCorreo(), e.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_EMPRESA")));
        }

        // 2. Buscar como oferente
        var oferente = oferenteRepo.findByCorreo(username);
        if (oferente.isPresent()) {
            Oferente o = oferente.get();
            if (!o.getAprobado()) throw new UsernameNotFoundException("Oferente no aprobado");
            return new User(o.getCorreo(), o.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_OFERENTE")));
        }

        // 3. Buscar como administrador (usa identificacion como usuario)
        var admin = adminRepo.findByIdentificacion(username);
        if (admin.isPresent()) {
            Administrador a = admin.get();
            return new User(a.getIdentificacion(), a.getClave(),
                    List.of(new SimpleGrantedAuthority("ROLE_ADMIN")));
        }

        throw new UsernameNotFoundException("Usuario no encontrado: " + username);
    }
}